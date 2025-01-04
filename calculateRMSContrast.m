function contrastValue = calculateRMSContrast(image)
% CALCULATERMSCONTRAST calculates the RMS contrast of the input image.
%
% INPUT:
% image - Input image (grayscale or color).
%
% OUTPUT:
% contrastValue - RMS contrast of the image.

% Check if the image is grayscale
if size(image, 3) == 3
    % Convert RGB image to grayscale
    grayImage = rgb2gray(image);
else
    grayImage = image;
end

% Converting to double and normalize pixel values to [0, 1]
grayImage = double(grayImage) / 255;

% Calculate the mean intensity
meanIntensity = mean(grayImage(:));

% Calculate the RMS contrast
contrastValue = sqrt(mean((double(grayImage(:)) - meanIntensity).^2));

end
