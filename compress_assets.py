import os
from PIL import Image

ASSETS_DIR = "assets"
BEFORE = 0
AFTER = 0

def compress_image(path):
    global BEFORE, AFTER
    original_size = os.path.getsize(path)
    
    if original_size < 10000:
        print("  SKIP  " + os.path.basename(path) + " (" + str(original_size//1024) + "KB)")
        return

    BEFORE += original_size
    img = Image.open(path).convert("RGBA")
    w, h = img.size
    filename = os.path.basename(path)

    if "profile" in filename:
        max_dim = 500
    elif "3d" in filename:
        max_dim = 300
    elif filename.startswith("project_") and "_admin" not in filename and "_user" not in filename:
        max_dim = 600
    else:
        max_dim = 700

    if max(w, h) > max_dim:
        ratio = max_dim / max(w, h)
        new_size = (int(w * ratio), int(h * ratio))
        img = img.resize(new_size, Image.LANCZOS)

    img.save(path, "PNG", optimize=True, compress_level=9)
    
    new_bytes = os.path.getsize(path)
    AFTER += new_bytes
    reduction = ((original_size - new_bytes) / original_size) * 100
    print("  OK  " + filename + "  " + str(original_size//1024) + "KB -> " + str(new_bytes//1024) + "KB  (" + str(round(reduction)) + "% saved)")

print("=== Compressing assets ===")
for fname in sorted(os.listdir(ASSETS_DIR)):
    if fname.lower().endswith(".png"):
        compress_image(os.path.join(ASSETS_DIR, fname))

print("")
print("=== TOTAL: " + str(BEFORE//1024//1024) + "MB -> " + str(AFTER//1024//1024) + "MB  (saved " + str((BEFORE-AFTER)//1024//1024) + "MB) ===")
