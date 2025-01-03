function [grayImage, weights] = convertToGrayscale(image)
    % Check if the image is already grayscale or binary
    if size(image, 3) == 1
        % If the image is grayscale or binary, no conversion needed
        grayImage = image;

        % Calculate contrast for the grayscale image
        contrast = max(grayImage(:)) - min(grayImage(:));

        weights = [1, 0, 0, contrast]; % Default weights for grayscale images
        return;
    end

    % Extract the Red, Green, and Blue channels
    R = double(image(:, :, 1));
    G = double(image(:, :, 2));
    B = double(image(:, :, 3));

    % Initialize variables to track the best weights and maximum contrast
    best_contrast = 0;    % Variable to store the maximum contrast
    best_weights = [0, 0, 0]; % Variable to store the best weights

    % Iterate over weight combinations to compute grayscale images
    for w_R = 0:0.01:1  % Adjust granularity as needed
        for w_G = 0:0.01:(1 - w_R) % Ensure weights sum to 1
            w_B = 1 - w_R - w_G;  % Compute Blue weight automatically

            % Compute the grayscale image for the current weights
            Gray = w_R * R + w_G * G + w_B * B;

            % Compute the contrast (max - min)
            current_contrast = max(Gray(:)) - min(Gray(:));

            % Check if the current contrast is the best
            if current_contrast > best_contrast
                best_contrast = current_contrast;
                best_weights = [w_R, w_G, w_B, best_contrast];
            end
        end
    end

    % Use the best weights to compute the final grayscale image
    grayImage = best_weights(1) * R + best_weights(2) * G + best_weights(3) * B;
    weights = best_weights; % Return the best weights
end
