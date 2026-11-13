import os
import sys
import shutil
import zipfile
import lief
import tempfile

def inject_dylib_to_ipa(ipa_path, dylib_path, output_path):
    print(f"[*] Bóc IPA: {ipa_path}")
    temp_dir = tempfile.mkdtemp()
    
    with zipfile.ZipFile(ipa_path, 'r') as zip_ref:
        zip_ref.extractall(temp_dir)

    payload_dir = os.path.join(temp_dir, "Payload")
    app_dirs = [d for d in os.listdir(payload_dir) if d.endswith('.app')]
    
    if not app_dirs:
        print("[-] Không tìm thấy .app trong Payload")
        return

    app_dir = os.path.join(payload_dir, app_dirs[0])
    app_name = app_dirs[0].replace('.app', '') 
    binary_path = os.path.join(app_dir, app_name)

    if not os.path.exists(binary_path):
        print("[-] Không tìm thấy file binary thực thi")
        return

    print(f"[*] Patch Binary: {binary_path}")
    binary = lief.parse(binary_path)
    
    dest_dylib_name = "FFMaxHack.dylib"
    dest_dylib_path = os.path.join(app_dir, dest_dylib_name)
    shutil.copy(dylib_path, dest_dylib_path)
    
    load_path = f"@executable_path/{dest_dylib_name}"
    binary.add_library(load_path)
    binary.write(binary_path)

    print(f"[*] Đóng gói IPA mới: {output_path}")
    with zipfile.ZipFile(output_path, 'w', zipfile.ZIP_DEFLATED) as zipf:
        for root, dirs, files in os.walk(temp_dir):
            for file in files:
                file_path = os.path.join(root, file)
                arcname = os.path.relpath(file_path, temp_dir)
                zipf.write(file_path, arcname)

    shutil.rmtree(temp_dir)
    print("[+] Xong! Kéo file IPA vào TrollStore để cài.")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Cách dùng: python inject_ipa.py <file_goc.ipa> <file_tweak.dylib>")
        sys.exit(1)
        
    ipa_input = sys.argv[1]
    dylib_input = sys.argv[2]
    ipa_output = ipa_input.replace(".ipa", "_patched.ipa")
    inject_dylib_to_ipa(ipa_input, dylib_input, ipa_output)
