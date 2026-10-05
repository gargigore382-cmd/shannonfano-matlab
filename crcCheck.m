function [isValid, remainder] = crcCheck(receivedFrame)

% ================================================================
% CRC CHECKING
% ================================================================

generator = '1101';

receivedFrame = char(receivedFrame);

working = receivedFrame - '0';
gen = generator - '0';

% Modulo-2 division
for i = 1:(length(working)-length(gen)+1)

    if working(i) == 1

        working(i:i+length(gen)-1) = ...
            xor(working(i:i+length(gen)-1),gen);

    end

end

% Final remainder
r = length(gen)-1;

remainder = char(working(end-r+1:end) + '0');

% Check whether remainder is all zeros
isValid = all(remainder == '0');

end