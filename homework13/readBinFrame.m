function C = readBinFrame(filnam,frame)
    % Read a frame (1-based) from a binary file.
    % The output frame has a number of interleaved channels (e.g. B, G, R) as consecutive columns.
    % If 0 == frame, the number of frames (frameCount) is returned.

    fileID = fopen(filnam,'r');
    header = fread(fileID,[4 1],'uint32'); % rows,cols,channels,depth

    rows = header(1);
    cols = header(2);
    channels = header(3);
    depth = header(4); % 0:uint8, 1:int8, 2:uint16, 3:int16, 4:int32, 5:float32, 6:float64, 7:float16

    precision = {'uint8', 'int8', 'uint16', 'int16', 'int32', 'float', 'double', 'float16'}; % 'float16' does not exist

    bytesPerElement = 2^(floor(depth/2)); % not valid if depth == 7
    bytesPerFrame = rows*cols*channels*bytesPerElement;

    if (0 == frame)
        fseek(fileID, 0, 'eof');
        fileLength = ftell(fileID);
        frameCount = (fileLength-4*4)/bytesPerFrame;
        data = frameCount;
        
        C = data;
    else
        fseek(fileID, 4*4+(frame-1)*bytesPerFrame, 'bof');
        data = fread(fileID, [cols*channels rows], precision{depth+1})';
        
%         C = data; 
        
%         C(:,:,1) = data(1:3:end,:); % B
%         C(:,:,2) = data(2:3:end,:); % B
%         C(:,:,3) = data(3:3:end,:); % B
%         C(:,:,2) = data(:,2:3:end); % G
%         C(:,:,1) = data(:,3:3:end); % R
        
        % convert data into RGB channels (OpenCV BGR order)
        C(:,:,3) = data(:,1:3:end); % B
        C(:,:,2) = data(:,2:3:end); % G
        C(:,:,1) = data(:,3:3:end); % R
%         C(:,:,4) = data(:,4:4:end); % B

    end

    fclose(fileID);

end


% function data = readBinFrame(filnam, frame)
%    
%     fileID = fopen(filnam,'r');
%     header = fread(fileID,[4 1],'uint32'); % rows,cols,channels,depth
% 
%     rows = header(1);
%     cols = header(2);
%     channels = header(3);
%     depth = header(4); % 0:uint8, 1:int8, 2:uint16, 3:int16, 4:int32, 5:float32, 6:float64, 7:float16
% 
%     precision = {'uint8', 'int8', 'uint16', 'int16', 'int32', 'float', 'double', 'float16'}; % 'float16' does not exist
% 
%     bytesPerElement = 2^(floor(depth/2)); % not valid if depth == 7
%     bytesPerFrame = rows*cols*channels*bytesPerElement;
% 
%     fseek(fileID, 4*4+(frame-1)*bytesPerFrame, 'bof');
%     data = fread(fileID, [cols*channels rows], precision{depth+1})';
% 
%     fclose(fileID);
% 
% end
