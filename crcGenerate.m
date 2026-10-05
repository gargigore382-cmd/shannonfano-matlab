function [transmittedFrame, crcBits] = crcGenerate(dataBits)

% ================================================================
% CRC GENERATION
% ================================================================

% CRC generator polynomial
generator = '1101';

dataBits = char(dataBits);
generator = char(generator);

% Number of zeros to append
r = length(generator) - 1;

% Append zeros
workingBits = [dataBits repmat('0',1,r)];

% Convert to numeric array
working = workingBits - '0';
gen = generator - '0';

% Modulo-2 division
for i = 1:(length(working)-length(gen)+1)

    if working(i) == 1

        working(i:i+length(gen)-1) = ...
            xor(working(i:i+length(gen)-1),gen);

    end

end

% CRC remainder
remainder = working(end-r+1:end);

crcBits = char(remainder + '0');

% Final transmitted frame
transmittedFrame = [dataBits crcBits];

end