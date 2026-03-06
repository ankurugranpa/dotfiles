#!/usr/bin/env python3
from __future__ import annotations

import argparse
from pathlib import Path
import shutil
import numpy as np
from PIL import Image
import cv2
import random


def find_pairs(src_root: Path, img_ext: str, mask_exts: list[str]):
    """
    src_root以下を再帰して img_ext を探し、同名の mask_exts をマスクとしてペア化。
    """
    img_ext = img_ext.lower().lstrip(".")
    mask_exts = [e.lower().lstrip(".") for e in mask_exts]

    pairs = []
    for img_path in src_root.rglob(f"*.{img_ext}"):
        mask_path = None
        for mext in mask_exts:
            cand = img_path.with_suffix(f".{mext}")
            if cand.exists():
                mask_path = cand
                break
        if mask_path is not None:
            pairs.append((img_path, mask_path))
    return pairs


def mask_to_polygons(mask_bin_u8: np.ndarray, min_area: float, approx_eps: float):
    """
    二値マスク(0/255) -> 外形ポリゴン群（複数インスタンス）
    """
    contours, _ = cv2.findContours(mask_bin_u8, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    polys = []
    for cnt in contours:
        area = cv2.contourArea(cnt)
        if area < min_area:
            continue

        approx = cv2.approxPolyDP(cnt, epsilon=approx_eps, closed=True)
        if len(approx) < 3:
            continue

        poly = approx.reshape(-1, 2)  # (N,2)
        polys.append(poly)

    return polys


def write_yolo_seg_label(lbl_path: Path, polys, w: int, h: int, class_id: int):
    """
    YOLOv8-seg形式: 1行 = 1インスタンス
    "cls x1 y1 x2 y2 ... (0..1 正規化)"
    """
    lines = []
    for poly in polys:
        xy = poly.astype(np.float32)
        xy[:, 0] /= float(w)
        xy[:, 1] /= float(h)
        xy = np.clip(xy, 0.0, 1.0)

        flat = xy.reshape(-1)
        line = str(class_id) + " " + " ".join(f"{v:.6f}" for v in flat.tolist())
        lines.append(line)

    lbl_path.parent.mkdir(parents=True, exist_ok=True)
    lbl_path.write_text("\n".join(lines) + ("\n" if lines else ""), encoding="utf-8")


def out_paths(
    img_path: Path,
    split: str,
    src_root: Path,
    out_root: Path,
    keep_subdirs: bool,
    img_ext_out: str,
):
    """
    出力先パスを返す。
    keep_subdirs=True のときはサブdir構造を維持。
    """
    rel = img_path.relative_to(src_root)
    img_ext_out = img_ext_out.lower().lstrip(".")  # e.g. "png"

    if keep_subdirs:
        out_img = out_root / "images" / split / rel.with_suffix(f".{img_ext_out}")
        out_lbl = out_root / "labels" / split / rel.with_suffix(".txt")
    else:
        out_img = out_root / "images" / split / img_path.with_suffix(f".{img_ext_out}").name
        out_lbl = out_root / "labels" / split / (img_path.stem + ".txt")
    return out_img, out_lbl


def split_pairs(pairs: list[tuple[Path, Path]], mode: str, val_count: int, seed: int):
    """
    mode:
      - tail   : ソートして末尾 val_count を val
      - random : seed付きでシャッフルして先頭 val_count を val
    """
    if val_count <= 0:
        raise ValueError("--val-count must be > 0")

    if mode == "tail":
        pairs_sorted = sorted(pairs, key=lambda x: str(x[0]).lower())
        if len(pairs_sorted) <= val_count:
            raise RuntimeError(f"データ数({len(pairs_sorted)})が val_count({val_count})以下です。")
        train_pairs = pairs_sorted[:-val_count]
        val_pairs = pairs_sorted[-val_count:]
        return train_pairs, val_pairs

    if mode == "random":
        pairs_sorted = sorted(pairs, key=lambda x: str(x[0]).lower())
        rng = random.Random(seed)
        rng.shuffle(pairs_sorted)
        if len(pairs_sorted) <= val_count:
            raise RuntimeError(f"データ数({len(pairs_sorted)})が val_count({val_count})以下です。")
        val_pairs = pairs_sorted[:val_count]
        train_pairs = pairs_sorted[val_count:]
        return train_pairs, val_pairs

    raise ValueError(f"Unknown split mode: {mode}")


def parse_args():
    ap = argparse.ArgumentParser(
        description="Prepare YOLO segmentation dataset from (image, mask) pairs."
    )

    ap.add_argument("--src-root", type=Path, required=True, help="入力データのルート（再帰探索）")
    ap.add_argument("--out-root", type=Path, default=Path("dataset"), help="出力先ルート")

    ap.add_argument("--val-count", type=int, default=10, help="検証データ数（固定枚数）")
    ap.add_argument("--split-mode", choices=["tail", "random"], default="tail",
                    help="tail: ソート後末尾N枚をval / random: seedでシャッフルしてN枚をval")
    ap.add_argument("--seed", type=int, default=42, help="split-mode=random 用のseed")

    ap.add_argument("--class-id", type=int, default=0, help="YOLOクラスID（0始まり）")

    ap.add_argument("--thresh", type=int, default=127, help="二値化閾値（白が対象）")
    ap.add_argument("--min-area", type=float, default=50, help="小領域除外の面積閾値(px^2)")
    ap.add_argument("--approx-eps", type=float, default=1.0, help="ポリゴン簡略化 epsilon（大きいほど頂点減）")

    ap.add_argument("--copy-subdir-structure", action="store_true",
                    help="srcのサブディレクトリ構造を保持して出力する")

    ap.add_argument("--img-ext", default="png", help="入力画像拡張子（例: png, jpg）")
    ap.add_argument("--mask-exts", default="tif,tiff",
                    help="マスク拡張子の候補（カンマ区切り）例: tif,tiff,png")

    ap.add_argument("--out-img-ext", default="png",
                    help="出力画像拡張子（コピーなので基本は入力と同じでOK）")

    ap.add_argument("--overwrite", action="store_true",
                    help="out-root が既にある場合に削除して作り直す")

    return ap.parse_args()


def main():
    args = parse_args()

    src_root: Path = args.src_root
    out_root: Path = args.out_root

    if not src_root.exists():
        raise SystemExit(f"[ERROR] src-root not found: {src_root}")

    if out_root.exists() and args.overwrite:
        shutil.rmtree(out_root)

    out_root.mkdir(parents=True, exist_ok=True)

    mask_exts = [s.strip() for s in str(args.mask_exts).split(",") if s.strip()]
    pairs = find_pairs(src_root, args.img_ext, mask_exts)
    if not pairs:
        raise RuntimeError("画像と同名のマスクが見つかりませんでした。拡張子やパスを確認してください。")

    train_pairs, val_pairs = split_pairs(pairs, args.split_mode, args.val_count, args.seed)

    def process(split: str, split_pairs: list[tuple[Path, Path]]):
        for img_path, mask_path in split_pairs:
            # 画像サイズ取得
            with Image.open(img_path) as im:
                w, h = im.size

            # マスク読み込み -> 二値化
            with Image.open(mask_path) as mm:
                mm = mm.convert("L")
                mask = np.array(mm)

            _, binmask = cv2.threshold(mask, int(args.thresh), 255, cv2.THRESH_BINARY)

            polys = mask_to_polygons(binmask, min_area=float(args.min_area), approx_eps=float(args.approx_eps))

            out_img, out_lbl = out_paths(
                img_path=img_path,
                split=split,
                src_root=src_root,
                out_root=out_root,
                keep_subdirs=bool(args.copy_subdir_structure),
                img_ext_out=str(args.out_img_ext),
            )
            out_img.parent.mkdir(parents=True, exist_ok=True)

            # 画像コピー
            shutil.copy2(img_path, out_img)

            # ラベル生成（polysが空なら空行=ラベル無し画像として扱われる）
            write_yolo_seg_label(out_lbl, polys, w, h, int(args.class_id))

    process("train", train_pairs)
    process("val", val_pairs)

    print("Done.")
    print(f"Total : {len(pairs)}")
    print(f"Train : {len(train_pairs)}")
    print(f"Val   : {len(val_pairs)}")
    print(f"Out   : {out_root.resolve()}")


if __name__ == "__main__":
    main()
