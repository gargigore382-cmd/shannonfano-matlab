clc;
clear;
close all;

fprintf('\n');
fprintf('============================================================\n');
fprintf('                SHANNON-FANO RECEIVER\n');
fprintf('============================================================\n');


%% STEP 1: CHECK FOR TRANSMISSION DATA

if ~exist('channel.mat', 'file')

    fprintf('\nNo transmission data found.\n');

    fprintf('\nPlease run transmitter first.\n');

    return;

end


%% STEP 2: LOAD TRANSMISSION DATA

fprintf('\nReceiving data from channel...\n');

load('channel.mat');


%% STEP 3: DISPLAY RECEIVED FRAME

fprintf('\n');
fprintf('============================================================\n');
fprintf('                  RECEIVED FRAME\n');
fprintf('============================================================\n');

fprintf('\nTransmitted Frame:\n');

fprintf('%s\n', transmittedFrame);

fprintf('\nReceived Frame:\n');

fprintf('%s\n', receivedFrame);

fprintf('\nNumber of Channel Errors = %d\n', ...
    numberOfChannelErrors);


%% STEP 4: CRC CHECK

fprintf('\n');
fprintf('============================================================\n');
fprintf('                   CRC ERROR CHECK\n');
fprintf('============================================================\n');

generator = '1101';

fprintf('\nGenerator Polynomial : %s\n', generator);


[crcPassed, remainder] = ...
    checkCRC(receivedFrame, generator);


receivedCRC = ...
    receivedFrame(end-2:end);


fprintf('\nReceived CRC Bits    : %s\n', ...
    receivedCRC);

fprintf('Calculated Remainder : %s\n', ...
    remainder);


%% STEP 5: ERROR DETECTION

if ~crcPassed

    fprintf('\n');
    fprintf('CRC RESULT : FAIL\n');

    fprintf('\n');
    fprintf('****************************************\n');
    fprintf('           ERROR DETECTED\n');
    fprintf('****************************************\n');

    fprintf('\nThe received frame is corrupted.\n');

    fprintf('\nShannon-Fano decoding will NOT be performed.\n');

    fprintf('\nTransmission has failed.\n');

    fprintf('\n');
    fprintf('============================================================\n');
    fprintf('                TRANSMISSION FAILED\n');
    fprintf('============================================================\n');

    return;

end


%% STEP 6: NO ERROR DETECTED

fprintf('\n');
fprintf('CRC RESULT : PASS\n');

fprintf('\n');
fprintf('****************************************\n');
fprintf('          NO ERROR DETECTED\n');
fprintf('****************************************\n');


%% STEP 7: REMOVE CRC BITS

receivedData = ...
    receivedFrame(1:end-3);


fprintf('\n');
fprintf('============================================================\n');
fprintf('              COMPRESSED DATA RECEIVED\n');
fprintf('============================================================\n');

fprintf('\nReceived Shannon-Fano Bits:\n');

fprintf('%s\n', receivedData);


%% STEP 8: SHANNON-FANO DECODING

fprintf('\n');
fprintf('============================================================\n');
fprintf('             SHANNON-FANO DECODING\n');
fprintf('============================================================\n');

fprintf('\n%-20s %-15s\n', ...
    'Received Code', 'Character');

fprintf('------------------------------------------------------------\n');


decodedText = '';

currentCode = '';


for i = 1:length(receivedData)

    currentCode = ...
        [currentCode receivedData(i)];


    for j = 1:length(codes)

        if strcmp(currentCode, codes{j})

            if symbols(j) == ' '

                displayChar = 'SPACE';

            else

                displayChar = symbols(j);

            end


            fprintf('%-20s %-15s\n', ...
                currentCode, ...
                displayChar);


            decodedText = ...
                [decodedText symbols(j)];


            currentCode = '';

            break;

        end

    end

end


%% STEP 9: DISPLAY FINAL MESSAGE

fprintf('\n');
fprintf('============================================================\n');
fprintf('                  RECEIVER OUTPUT\n');
fprintf('============================================================\n');

fprintf('\nOriginal Transmitted Text:\n');

fprintf('%s\n', text);

fprintf('\nDecoded Received Text:\n');

fprintf('%s\n', decodedText);


%% STEP 10: VERIFY MESSAGE

if strcmp(decodedText, text)

    fprintf('\nMESSAGE VERIFICATION : SUCCESS\n');

else

    fprintf('\nMESSAGE VERIFICATION : FAILED\n');

end


%% STEP 11: RECEIVER SUMMARY

fprintf('\n');
fprintf('============================================================\n');
fprintf('                  RECEIVER SUMMARY\n');
fprintf('============================================================\n');

fprintf('\nOriginal Message       : %s\n', text);

fprintf('Received Message       : %s\n', decodedText);

fprintf('\nOriginal Size          : %d bits\n', ...
    originalBits);

fprintf('Compressed Size        : %d bits\n', ...
    compressedBits);

fprintf('Entropy                : %.4f bits/symbol\n', ...
    entropy);

fprintf('Average Code Length    : %.4f bits/symbol\n', ...
    averageCodeLength);

fprintf('Coding Efficiency      : %.2f %%\n', ...
    efficiency);

fprintf('Compression Ratio      : %.2f : 1\n', ...
    compressionRatio);

fprintf('Space Saved            : %.2f %%\n', ...
    spaceSaved);

fprintf('\nCRC Status             : PASS\n');

fprintf('Channel Errors         : %d\n', ...
    numberOfChannelErrors);

fprintf('\nTransmission Status    : SUCCESSFUL\n');


fprintf('\n');
fprintf('============================================================\n');
fprintf('                RECEIVER COMPLETED\n');
fprintf('============================================================\n');


%% =========================================================
% LOCAL FUNCTION: CRC CHECK
% ==========================================================

function [result, remainderBits] = ...
    checkCRC(receivedFrame, generator)


data = double(receivedFrame) - double('0');

gen = double(generator) - double('0');


for i = 1:length(data)-length(gen)+1

    if data(i) == 1

        data(i:i+length(gen)-1) = ...
            xor(data(i:i+length(gen)-1), gen);

    end

end


remainder = data(end-2:end);


remainderBits = ...
    char(remainder + double('0'));


if all(remainder == 0)

    result = true;

else

    result = false;

end

end