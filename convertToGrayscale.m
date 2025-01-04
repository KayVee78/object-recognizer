function [grayImage, weights] = convertToGrayscale(image)
% Check if the image is already grayscale or binary
if size(image, 3) == 1
    % If the image is grayscale or binary, no conversion
    grayImage = image;

    % Calculate contrast for the grayscale image
    contrast = max(grayImage(:)) - min(grayImage(:));

    weights = [1, 0, 0, contrast]; % Default weights for grayscale images
    return;
end

% Extract the R,G.B channels
R = double(image(:, :, 1));
G = double(image(:, :, 2));
B = double(image(:, :, 3));

% Initialize variables
best_contrast = 0;    % store the maximum contrast
best_weights = [0, 0, 0]; % store the best weights

% Iterate over weight combinations to compute grayscale images
for w_R = 0:0.01:1  % Adjust granularity
    for w_G = 0:0.01:(1 - w_R) % Ensure weights sum to 1
        w_B = 1 - w_R - w_G;  % Computes Blue weight automatically

        % Computes the grayscale image for current weights
        Gray = w_R * R + w_G * G + w_B * B;

        % Computes the contrast (max - min)
        current_contrast = max(Gray(:)) - min(Gray(:));

        % Checking if the current contrast is the best
        if current_contrast > best_contrast
            best_contrast = current_contrast;
            best_weights = [w_R, w_G, w_B, best_contrast];
        end
    end
end

% Using best weights to compute the final grayscale image
grayImage = best_weights(1) * R + best_weights(2) * G + best_weights(3) * B;
weights = best_weights;
end
