import os

main_path = r"c:\Users\premk\OneDrive\Documents\prem_port\prem_portfolio\lib\main.dart"

with open(main_path, "r", encoding="utf-8") as f:
    lines = f.readlines()

print(f"Original line count: {len(lines)}")

# Keep only the first 2907 lines
truncated_lines = lines[:2907]
content = "".join(truncated_lines)

# Fix EdgeInsets.top(4)
old_str = "margin: const EdgeInsets.top(4),"
new_str = "margin: const EdgeInsets.only(top: 4),"

if old_str in content:
    content = content.replace(old_str, new_str)
    print("Successfully replaced EdgeInsets.top(4)")
else:
    # Let's search for a looser match if space differs
    if "EdgeInsets.top(4)" in content:
        content = content.replace("EdgeInsets.top(4)", "EdgeInsets.only(top: 4)")
        print("Replaced EdgeInsets.top(4) with looser match")
    else:
        print("EdgeInsets.top(4) not found, checking...")

# Save the updated content back to main.dart
with open(main_path, "w", encoding="utf-8") as f:
    f.write(content)

print("lib/main.dart updated successfully!")
