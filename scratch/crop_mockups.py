import os
from PIL import Image

# Directory setup
assets_dir = r"c:\Users\premk\OneDrive\Documents\prem_port\prem_portfolio\assets"

source_images = {
    "seven_pay_services_user": r"C:\Users\premk\.gemini\antigravity-ide\brain\2059d2b0-3c26-413e-91b6-bb9c0f825674\seven_pay_services_user_composite_1781978688153.png",
    "seven_pay_services_admin": r"C:\Users\premk\.gemini\antigravity-ide\brain\2059d2b0-3c26-413e-91b6-bb9c0f825674\seven_pay_services_admin_composite_1781978704591.png",
    
    "ride_4_you_user": r"C:\Users\premk\.gemini\antigravity-ide\brain\2059d2b0-3c26-413e-91b6-bb9c0f825674\ride_4_you_user_composite_1781978720179.png",
    "ride_4_you_admin": r"C:\Users\premk\.gemini\antigravity-ide\brain\2059d2b0-3c26-413e-91b6-bb9c0f825674\ride_4_you_admin_composite_1781978738906.png",
    
    "alham_mutton_user": r"C:\Users\premk\.gemini\antigravity-ide\brain\2059d2b0-3c26-413e-91b6-bb9c0f825674\alham_mutton_user_composite_1781978752334.png",
    "alham_mutton_admin": r"C:\Users\premk\.gemini\antigravity-ide\brain\2059d2b0-3c26-413e-91b6-bb9c0f825674\alham_mutton_admin_composite_1781978766660.png",
    
    "rythu_rice_user": r"C:\Users\premk\.gemini\antigravity-ide\brain\2059d2b0-3c26-413e-91b6-bb9c0f825674\rythu_rice_user_composite_1781978782088.png",
    "rythu_rice_admin": r"C:\Users\premk\.gemini\antigravity-ide\brain\2059d2b0-3c26-413e-91b6-bb9c0f825674\rythu_rice_admin_composite_1781978798972.png",
    
    "meatoon_user": r"C:\Users\premk\.gemini\antigravity-ide\brain\2059d2b0-3c26-413e-91b6-bb9c0f825674\meatoon_user_composite_1781978813567.png",
    "meatoon_admin": r"C:\Users\premk\.gemini\antigravity-ide\brain\2059d2b0-3c26-413e-91b6-bb9c0f825674\meatoon_admin_composite_1781978831425.png",
    
    "fresh_fresh_user": r"C:\Users\premk\.gemini\antigravity-ide\brain\2059d2b0-3c26-413e-91b6-bb9c0f825674\fresh_fresh_user_composite_1781978844558.png",
    "fresh_fresh_admin": r"C:\Users\premk\.gemini\antigravity-ide\brain\2059d2b0-3c26-413e-91b6-bb9c0f825674\fresh_fresh_admin_composite_1781978859272.png",
    
    "church_app_user": r"C:\Users\premk\.gemini\antigravity-ide\brain\2059d2b0-3c26-413e-91b6-bb9c0f825674\church_app_user_composite_1781978875956.png",
    "church_app_admin": r"C:\Users\premk\.gemini\antigravity-ide\brain\2059d2b0-3c26-413e-91b6-bb9c0f825674\church_app_admin_composite_1781978893716.png",
}

for prefix, src_path in source_images.items():
    if not os.path.exists(src_path):
        print(f"ERROR: {src_path} does not exist!")
        continue
    
    img = Image.open(src_path)
    width, height = img.size
    print(f"Processing {prefix}: {width}x{height}")
    
    if prefix.endswith("_user"):
        # Crop horizontally into 3 equal columns
        col_width = width // 3
        for i in range(3):
            left = i * col_width
            right = (i + 1) * col_width if i < 2 else width
            box = (left, 0, right, height)
            cropped = img.crop(box)
            
            dest_name = f"project_{prefix}1.png" if i == 0 else (f"project_{prefix}2.png" if i == 1 else f"project_{prefix}3.png")
            # Replace final '_user1' etc correctly
            dest_name = dest_name.replace("_user1", "_user1").replace("_user2", "_user2").replace("_user3", "_user3")
            dest_path = os.path.join(assets_dir, dest_name)
            cropped.save(dest_path)
            print(f"Saved cropped User image: {dest_path}")
            
    elif prefix.endswith("_admin"):
        # Crop vertically into 2 equal rows
        row_height = height // 2
        for i in range(2):
            top = i * row_height
            bottom = (i + 1) * row_height if i < 1 else height
            box = (0, top, width, bottom)
            cropped = img.crop(box)
            
            dest_name = f"project_{prefix}1.png" if i == 0 else f"project_{prefix}2.png"
            dest_path = os.path.join(assets_dir, dest_name)
            cropped.save(dest_path)
            print(f"Saved cropped Admin image: {dest_path}")

print("Slicing and asset generation complete!")
