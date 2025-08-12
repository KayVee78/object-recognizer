# 🎫 Object Recognizer (in Medical Images)

 This project is developed as the group coursework for the Sensors and Signals module (Year 3 – Semester 1), aims to create a comprehensive image processing application capable of analyzing medical images for potential tumor diagnosis. The application provides a user interface for uploading photos and performing various image processing operations, culminating in the enhancement and identification of tumor edges.

---

## 🗝️ Key Features

- **Image Upload and Display**: Supports WebP, JPEG, and PNG formats, with built-in Python integration to convert WebP images to PNG.
- **Contrast Calculation**: Computes the Root Mean Square (RMS) contrast of uploaded images, including iteration through various RGB weight combinations for colour images.
- **Grayscale Conversion**: Converts colour (RGB) images to grayscale using specific luminance weights (0.299 for Red, 0.587 for Green, 0.114 for Blue).
- **Histogram Generation**:   Creates a pixel intensity histogram for uploaded images, converting RGB to grayscale first if necessary.
- **Tumour Edge Enhancement and Feature Extraction**: Processes grayscale images through a series of filters and morphological operations to enhance tumor edges and extract features for detection. This includes Gaussian filtering, contrast enhancement, adaptive thresholding, median filtering, morphological closing, and elliptical masking. Tumour boundaries are then extracted and plotted.

<img width="556" height="412" alt="jpeg" src="https://github.com/user-attachments/assets/af195c6f-2e8a-4d03-8072-476ca96db6da" />
<br/>
<img width="555" height="409" alt="png" src="https://github.com/user-attachments/assets/ff285b10-6335-4385-8204-94fd7ac6d4b4" />

---

## ♦️ Prerequisites

Ensure that **Image Processing Toolbox** is installed/enabled in the Matlab environment.<br/>
(If you have a license, install it via MATLAB Add-On Explorer)

---

## 🛠 Technologies Used

   ![Python]: Integrated for handling and converting WebP image formats, as MATLAB does not natively support WebP.
   <br/><br/>
   ![Matlab]: Core development environment and primary programming language for image processing functions and UI creation


---

## 👩‍💻 Authors

**Kithmi Hettiarachchi**  
**Danilka Jayasooriya** <br/>
**Nilupul Suramya**

---

Happy coding! ☕




<!-- MARKDOWN LINKS & IMAGES -->
[Python]: https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white
[Matlab]: https://img.shields.io/badge/Matlab-B24619?style=for-the-badge
