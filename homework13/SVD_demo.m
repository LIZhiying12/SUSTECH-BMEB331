clear;clc;

% Read data
filnam = "./baby.bin";
FrameNum = readBinFrame(filnam, 0);
im = readBinFrame(filnam, 1); % define frame index

imagesc(uint8(im(:,:,:)));drawnow;
roi = drawpolygon('Color', [0 0.4470 0.7410]); %  specifies the shape and position of a polygonal region of interest (ROI)

mask = createMask(roi);
rgb_data = [];

for idx = 1 : FrameNum
    im = readBinFrame(filnam, idx);
    imagesc(uint8(im(:,:,:)));drawnow;
    B = im(:,:,1);
    G = im(:,:,2);
    R = im(:,:,3);
   
    % color traces
    c_r = mean(R(mask == 1));
    c_g = mean(G(mask == 1));
    c_b = mean(B(mask == 1));
    rgb_data = [rgb_data, [c_r; c_g; c_b]];

    disp(num2str(idx) +  "|" + num2str(FrameNum));

end

RGB = rgb_data';

% DC normalize
normalized_RGB = (RGB - mean(RGB, 1)) ./ std(RGB, 0, 1);

% Filter
fs = 20;
nyq = 0.5 * fs;
low = 0.6 / nyq;
high = 3 / nyq;
[b, a] = butter(4, [low, high], 'bandpass');
filtered_RGB = filtfilt(b, a, normalized_RGB);

% SVD
[U, S, V] = svd(filtered_RGB, 'econ');

% Extract the best signal
projected_signals = filtered_RGB * V;
F = fft(projected_signals', [], 2);
S = abs(F(:, 1:floor(end / 2) - 1));
snr = max(S, [], 2) ./ (sum(S, 2) - max(S, [], 2));
[~, best_signal_idx] = max(snr);
best_signal = projected_signals(:, best_signal_idx);

% Plot
[best_signal_spc, ~] = spec(best_signal', fs);
figure, set(gcf, 'Position', [100 100 1200 250]); colormap('jet');
subplot(1, 2, 1);
plot(best_signal);

subplot(1, 2, 2);
imagesc(best_signal_spc(1:200, :)); set(gca, 'YDir', 'normal');
