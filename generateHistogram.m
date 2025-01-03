function histData = generateHistogram(grayImage)
    % Ensure the image is grayscale
    if size(grayImage, 3) ~= 1
        error('Input must be a grayscale image');
    end

    % Clamp and round pixel values to integers in the range [0, 255]
    grayImage = round(grayImage);
    grayImage = max(0, min(255, grayImage));

    % Initialize histogram array (256 bins for pixel values 0-255)
    histData = zeros(1, 256);

    % Loop through each pixel in the image
    for i = 1:numel(grayImage)
        pixelValue = grayImage(i); % Get pixel value
        histData(pixelValue + 1) = histData(pixelValue + 1) + 1;
    end
end
