from PIL import Image
import sys

def convert_webp_to_png(input_path, output_path):
    try:
        with Image.open(input_path) as img:
            img.save(output_path, 'PNG')  # You can change 'PNG' to 'JPEG' if needed
        print("Conversion successful")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python convert_webp.py <input_path> <output_path>")
    else:
        input_path = sys.argv[1]
        output_path = sys.argv[2]
        convert_webp_to_png(input_path, output_path)
