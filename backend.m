function results = backend(message)
% ================================================================
% SHANNON-FANO DIGITAL COMMUNICATION PROJECT
% COMPLETE BACKEND
%
% Performs:
%   1. Frequency analysis
%   2. Probability calculation
%   3. Sorting
%   4. Shannon-Fano partitioning
%   5. Code table
%   6. Character-by-character encoding
%   7. Entropy
%   8. Average code length
%   9. Coding efficiency
%  10. Original bits
%  11. Compressed bits
%  12. Compression ratio
%  13. CRC generation
%  14. Automatic transmission channel
%  15. Bit-by-bit comparison
%  16. CRC error detection
%  17. Shannon-Fano decoding
%  18. Final summary
% ================================================================

clc;

%% ================================================================
% INPUT
% ================================================================

if nargin == 0
    message = 'GOOD MORNING';
end

message = char(message);

%% ================================================================
% CREATE BACKEND WINDOW
% ================================================================

fig = uifigure( ...
    'Name','Shannon-Fano Backend Calculation Inspector', ...
    'Position',[80 40 1100 780]);

uilabel(fig, ...
    'Text','SHANNON-FANO BACKEND CALCULATION INSPECTOR', ...
    'Position',[30 735 1040 30], ...
    'FontSize',19, ...
    'FontWeight','bold', ...
    'HorizontalAlignment','center');

uilabel(fig, ...
    'Text','Complete step-by-step calculations', ...
    'Position',[30 708 1040 22], ...
    'FontSize',12, ...
    'HorizontalAlignment','center');

outputBox = uitextarea(fig, ...
    'Position',[25 25 1050 665], ...
    'Editable','off', ...
    'FontName','Courier New', ...
    'FontSize',12);

%% ================================================================
% OUTPUT STORAGE
% ================================================================

out = {};

addLine('==============================================================');
addLine('       SHANNON-FANO DIGITAL COMMUNICATION PROJECT');
addLine('             BACKEND CALCULATION INSPECTOR');
addLine('==============================================================');
addLine('');

%% ================================================================
% STEP 0
% ================================================================

addLine('STEP 0: INPUT MESSAGE');
addLine('--------------------------------------------------------------');
addLine(['Input message = "',message,'"']);
addLine('');

N = length(message);

addLine(['Number of characters = ',num2str(N)]);
addLine('');

%% ================================================================
% STEP 1 - FREQUENCY
% ================================================================

addLine('STEP 1: CHARACTER FREQUENCY ANALYSIS');
addLine('--------------------------------------------------------------');

symbols = unique(message,'stable');

frequency = zeros(1,length(symbols));

for i = 1:length(symbols)
    frequency(i) = sum(message == symbols(i));
end

[frequency,sortIndex] = sort(frequency,'descend');
symbols = symbols(sortIndex);

addLine(sprintf('%-15s %-15s','Character','Frequency'));
addLine('--------------------------------------------------------------');

for i = 1:length(symbols)

    addLine(sprintf('%-15s %-15d', ...
        displaySymbol(symbols(i)), ...
        frequency(i)));

end

addLine('--------------------------------------------------------------');
addLine(['Total characters = ',num2str(sum(frequency))]);
addLine('');

%% ================================================================
% STEP 2 - PROBABILITY
% ================================================================

addLine('STEP 2: PROBABILITY CALCULATION');
addLine('--------------------------------------------------------------');

probability = frequency/N;

addLine(sprintf('%-15s %-15s %-20s', ...
    'Character','Frequency','Probability'));

addLine('--------------------------------------------------------------');

for i = 1:length(symbols)

    addLine(sprintf('%-15s %-15d %d/%d = %.6f', ...
        displaySymbol(symbols(i)), ...
        frequency(i), ...
        frequency(i), ...
        N, ...
        probability(i)));

end

addLine('');

%% ================================================================
% STEP 3 - SORTING
% ================================================================

addLine('STEP 3: SORTING BY PROBABILITY');
addLine('--------------------------------------------------------------');

for i = 1:length(symbols)

    addLine(sprintf('%d. %-15s Probability = %.6f', ...
        i, ...
        displaySymbol(symbols(i)), ...
        probability(i)));

end

addLine('');

%% ================================================================
% STEP 4 - SHANNON-FANO PARTITIONING
% ================================================================

addLine('STEP 4: SHANNON-FANO PARTITIONING');
addLine('--------------------------------------------------------------');

codes = repmat({''},1,length(symbols));

[codes,partitionText] = generateShannonFano( ...
    symbols,probability,codes,1:length(symbols),'');

for i = 1:length(partitionText)
    addLine(partitionText{i});
end

addLine('');

%% ================================================================
% STEP 5 - CODE TABLE
% ================================================================

addLine('STEP 5: FINAL SHANNON-FANO CODE TABLE');
addLine('--------------------------------------------------------------');

codeLengths = zeros(1,length(symbols));

addLine(sprintf('%-15s %-12s %-15s %-15s %-10s', ...
    'Character','Frequency','Probability','Code','Length'));

addLine('--------------------------------------------------------------');

for i = 1:length(symbols)

    codeLengths(i) = length(codes{i});

    addLine(sprintf('%-15s %-12d %-15.6f %-15s %-10d', ...
        displaySymbol(symbols(i)), ...
        frequency(i), ...
        probability(i), ...
        codes{i}, ...
        codeLengths(i)));

end

addLine('');

%% ================================================================
% STEP 6 - CHARACTER BY CHARACTER ENCODING
% ================================================================

addLine('STEP 6: CHARACTER-BY-CHARACTER ENCODING');
addLine('--------------------------------------------------------------');

addLine(sprintf('%-10s %-15s %-20s', ...
    'Position','Character','Encoded Code'));

addLine('--------------------------------------------------------------');

encodedStream = '';

for i = 1:length(message)

    currentChar = message(i);

    index = find(symbols == currentChar,1);

    currentCode = codes{index};

    encodedStream = [encodedStream currentCode];

    addLine(sprintf('%-10d %-15s %-20s', ...
        i, ...
        displaySymbol(currentChar), ...
        currentCode));

end

addLine('--------------------------------------------------------------');
addLine('COMPLETE SHANNON-FANO ENCODED STREAM:');
addLine(encodedStream);
addLine('');

%% ================================================================
% STEP 7 - ENTROPY
% ================================================================

addLine('STEP 7: SOURCE ENTROPY CALCULATION');
addLine('--------------------------------------------------------------');

addLine('Formula:');
addLine('H = - SUM [ P(x) * log2(P(x)) ]');
addLine('');

entropy = 0;

for i = 1:length(symbols)

    contribution = ...
        -probability(i)*log2(probability(i));

    entropy = entropy + contribution;

    addLine(sprintf( ...
        '%s: -%.6f * log2(%.6f) = %.6f', ...
        displaySymbol(symbols(i)), ...
        probability(i), ...
        probability(i), ...
        contribution));

end

addLine('');
addLine(sprintf('Entropy H = %.6f bits/symbol',entropy));
addLine('');

%% ================================================================
% STEP 8 - AVERAGE CODE LENGTH
% ================================================================

addLine('STEP 8: AVERAGE CODE LENGTH');
addLine('--------------------------------------------------------------');

addLine('Formula:');
addLine('L = SUM [ P(x) * Length(x) ]');
addLine('');

averageLength = 0;

for i = 1:length(symbols)

    contribution = ...
        probability(i)*codeLengths(i);

    averageLength = averageLength + contribution;

    addLine(sprintf( ...
        '%s: %.6f * %d = %.6f', ...
        displaySymbol(symbols(i)), ...
        probability(i), ...
        codeLengths(i), ...
        contribution));

end

addLine('');
addLine(sprintf( ...
    'Average Code Length L = %.6f bits/symbol', ...
    averageLength));

addLine('');

%% ================================================================
% STEP 9 - CODING EFFICIENCY
% ================================================================

addLine('STEP 9: CODING EFFICIENCY');
addLine('--------------------------------------------------------------');

efficiency = (entropy/averageLength)*100;

addLine('Formula:');
addLine('Efficiency = (Entropy / Average Code Length) * 100');
addLine('');

addLine(sprintf( ...
    'Efficiency = (%.6f / %.6f) * 100', ...
    entropy,averageLength));

addLine(sprintf('Coding Efficiency = %.2f %%',efficiency));
addLine('');

%% ================================================================
% STEP 10 - ORIGINAL BITS
% ================================================================

addLine('STEP 10: ORIGINAL MESSAGE SIZE');
addLine('--------------------------------------------------------------');

bitsPerCharacter = 8;

originalBits = N*bitsPerCharacter;

addLine('Assumption:');
addLine('Each original character is represented using 8 bits.');
addLine('');

addLine(['Characters = ',num2str(N)]);
addLine(['Bits per character = ',num2str(bitsPerCharacter)]);
addLine('');

addLine(sprintf( ...
    'Original Bits = %d * %d = %d bits', ...
    N,bitsPerCharacter,originalBits));

addLine('');

%% ================================================================
% STEP 11 - COMPRESSED BITS
% ================================================================

addLine('STEP 11: COMPRESSED MESSAGE SIZE');
addLine('--------------------------------------------------------------');

compressedBits = length(encodedStream);

addLine('Compressed size = total Shannon-Fano encoded bits.');
addLine('');

addLine(['Compressed Bits = ',num2str(compressedBits),' bits']);
addLine('');

%% ================================================================
% STEP 12 - COMPRESSION
% ================================================================

addLine('STEP 12: COMPRESSION CALCULATION');
addLine('--------------------------------------------------------------');

compressionRatio = originalBits/compressedBits;

spaceSaved = ...
    ((originalBits-compressedBits)/originalBits)*100;

addLine('Compression Ratio Formula:');
addLine('Compression Ratio = Original Bits / Compressed Bits');
addLine('');

addLine(sprintf( ...
    'Compression Ratio = %d / %d', ...
    originalBits,compressedBits));

addLine(sprintf( ...
    'Compression Ratio = %.4f : 1', ...
    compressionRatio));

addLine('');

addLine('Space Saved Formula:');
addLine('Space Saved = ((Original - Compressed) / Original) * 100');
addLine('');

addLine(sprintf( ...
    'Space Saved = ((%d - %d) / %d) * 100', ...
    originalBits,compressedBits,originalBits));

addLine(sprintf('Space Saved = %.2f %%',spaceSaved));
addLine('');

%% ================================================================
% STEP 13 - CRC GENERATION
% ================================================================

addLine('STEP 13: CRC GENERATION');
addLine('--------------------------------------------------------------');

generator = '1101';

addLine(['CRC Generator Polynomial = ',generator]);
addLine('');

addLine('Input to CRC = Shannon-Fano compressed stream');
addLine(encodedStream);
addLine('');

addLine('Step 13.1: Append zeros');
addLine('');

r = length(generator)-1;

crcInput = [encodedStream repmat('0',1,r)];

addLine(['Number of CRC zeros = ',num2str(r)]);
addLine(['Data after appending zeros = ',crcInput]);
addLine('');

% Call CRC function
[transmittedFrame,crcBits] = crcGenerate(encodedStream);

addLine('Step 13.2: Modulo-2 division');
addLine('');
addLine(['Generator = ',generator]);
addLine(['CRC Input = ',crcInput]);
addLine('');

addLine('Modulo-2 division is performed using XOR.');
addLine('');

% Show division result
working = crcInput-'0';
gen = generator-'0';

divisionSteps = {};

for i = 1:(length(working)-length(gen)+1)

    if working(i)==1

        before = char(working+'0');

        working(i:i+length(gen)-1) = ...
            xor(working(i:i+length(gen)-1),gen);

        after = char(working+'0');

        divisionSteps{end+1} = ...
            sprintf('Position %d: %s XOR %s -> %s', ...
            i,before,generator,after);

    end

end

for i = 1:length(divisionSteps)
    addLine(divisionSteps{i});
end

addLine('');

addLine(['CRC Remainder = ',crcBits]);
addLine('');

addLine(['Transmitted Frame = ',transmittedFrame]);
addLine('');

%% ================================================================
% STEP 14 - AUTOMATIC CHANNEL
% ================================================================

addLine('STEP 14: AUTOMATIC DIGITAL TRANSMISSION CHANNEL');
addLine('--------------------------------------------------------------');

errorProbability = 0;

addLine('Channel Model: Random Binary Error Channel');
addLine(sprintf( ...
    'Bit Error Probability = %.2f %%', ...
    errorProbability*100));

addLine('');

transmittedNumeric = transmittedFrame-'0';

randomValues = rand(size(transmittedNumeric));

errorMask = randomValues < errorProbability;

receivedNumeric = transmittedNumeric;

receivedNumeric(errorMask) = ...
    1-receivedNumeric(errorMask);

receivedFrame = char(receivedNumeric+'0');

numberOfErrors = sum(errorMask);

addLine('TRANSMITTED FRAME:');
addLine(transmittedFrame);
addLine('');

addLine('RECEIVED FRAME:');
addLine(receivedFrame);
addLine('');

addLine(['Number of Channel Errors = ', ...
    num2str(numberOfErrors)]);

addLine('');

%% ================================================================
% STEP 15 - BIT COMPARISON
% ================================================================

addLine('STEP 15: BIT-BY-BIT TRANSMISSION COMPARISON');
addLine('--------------------------------------------------------------');

addLine(sprintf( ...
    '%-10s %-10s %-10s %-15s', ...
    'Position','TX','RX','Status'));

addLine('--------------------------------------------------------------');

for i = 1:length(transmittedFrame)

    txBit = transmittedFrame(i);
    rxBit = receivedFrame(i);

    if txBit == rxBit
        status = 'OK';
    else
        status = 'ERROR';
    end

    addLine(sprintf( ...
        '%-10d %-10s %-10s %-15s', ...
        i,txBit,rxBit,status));

end

addLine('--------------------------------------------------------------');
addLine(['TOTAL BIT ERRORS = ',num2str(numberOfErrors)]);
addLine('');

%% ================================================================
% STEP 16 - CRC CHECK
% ================================================================

addLine('STEP 16: CRC ERROR DETECTION');
addLine('--------------------------------------------------------------');

addLine('Receiver performs CRC modulo-2 division.');
addLine('');

[crcValid,receivedRemainder] = ...
    crcCheck(receivedFrame);

addLine(['Received CRC Remainder = ',receivedRemainder]);
addLine('');

if crcValid

    addLine('CRC Remainder = 000');
    addLine('');
    addLine('CRC RESULT = PASS');
    addLine('NO TRANSMISSION ERROR DETECTED');

else

    addLine('CRC Remainder is non-zero.');
    addLine('');
    addLine('CRC RESULT = FAIL');
    addLine('ERROR DETECTED IN TRANSMISSION');

end

addLine('');

%% ================================================================
% STEP 17 - DECODING
% ================================================================

addLine('STEP 17: SHANNON-FANO DECODING');
addLine('--------------------------------------------------------------');

decodedMessage = '';

if crcValid

    receivedData = ...
        receivedFrame(1:length(encodedStream));

    addLine('CRC passed successfully.');
    addLine('CRC bits are removed.');
    addLine('');

    addLine('Received compressed data:');
    addLine(receivedData);
    addLine('');

    addLine('Character-by-character decoding:');
    addLine('');

    currentBits = '';

    for i = 1:length(receivedData)

        currentBits = ...
            [currentBits receivedData(i)];

        matchIndex = find( ...
            strcmp(codes,currentBits),1);

        if ~isempty(matchIndex)

            decodedChar = symbols(matchIndex);

            decodedMessage = ...
                [decodedMessage decodedChar];

            addLine(sprintf( ...
                '%-20s -> %s', ...
                currentBits, ...
                displaySymbol(decodedChar)));

            currentBits = '';

        end

    end

    addLine('');
    addLine('DECODED MESSAGE:');
    addLine(decodedMessage);
    addLine('');

    if strcmp(decodedMessage,message)

        addLine('MESSAGE VERIFICATION = SUCCESS');

    else

        addLine('MESSAGE VERIFICATION = FAILED');

    end

else

    addLine('CRC FAILED.');
    addLine('');
    addLine('The received compressed data is rejected.');
    addLine('');
    addLine('Shannon-Fano decoding is NOT performed.');
    addLine('');
    addLine('Reason: transmission error detected.');

end

addLine('');

%% ================================================================
% STEP 18 - FINAL SUMMARY
% ================================================================

addLine('==============================================================');
addLine('                    STEP 18: FINAL SUMMARY');
addLine('==============================================================');

addLine(['Original Message    : ',message]);
addLine(['Characters          : ',num2str(N)]);
addLine(['Original Bits       : ',num2str(originalBits)]);
addLine(['Compressed Bits     : ',num2str(compressedBits)]);
addLine(['CRC Bits            : ',num2str(length(crcBits))]);
addLine(['Total Frame Bits    : ',num2str(length(transmittedFrame))]);
addLine(['Compression Ratio   : ', ...
    sprintf('%.4f : 1',compressionRatio)]);
addLine(['Space Saved         : ', ...
    sprintf('%.2f %%',spaceSaved)]);
addLine(['Entropy             : ', ...
    sprintf('%.6f bits/symbol',entropy)]);
addLine(['Average Code Length : ', ...
    sprintf('%.6f bits/symbol',averageLength)]);
addLine(['Coding Efficiency   : ', ...
    sprintf('%.2f %%',efficiency)]);
addLine(['Channel Errors      : ',num2str(numberOfErrors)]);

if crcValid

    addLine('CRC Status          : PASS');
    addLine('Transmission Status : SUCCESSFUL');
    addLine(['Received Message    : ',decodedMessage]);

else

    addLine('CRC Status          : FAIL');
    addLine('Transmission Status : ERROR DETECTED');
    addLine('Received Message    : REJECTED');

end

addLine('==============================================================');
addLine('              ALL BACKEND CALCULATIONS COMPLETE');
addLine('==============================================================');

%% ================================================================
% DISPLAY EVERYTHING
% ================================================================

outputBox.Value = out;

%% ================================================================
% RESULTS STRUCTURE
% ================================================================

results.message = message;
results.symbols = symbols;
results.frequency = frequency;
results.probability = probability;
results.codes = codes;
results.encodedStream = encodedStream;

results.entropy = entropy;
results.averageLength = averageLength;
results.efficiency = efficiency;

results.originalBits = originalBits;
results.compressedBits = compressedBits;
results.compressionRatio = compressionRatio;
results.spaceSaved = spaceSaved;

results.generator = generator;
results.crcBits = crcBits;
results.transmittedFrame = transmittedFrame;
results.receivedFrame = receivedFrame;
results.numberOfErrors = numberOfErrors;
results.crcValid = crcValid;
results.receivedRemainder = receivedRemainder;
results.decodedMessage = decodedMessage;

%% ================================================================
% GRAPH 1 - FREQUENCY
% ================================================================

figure( ...
    'Name','Character Frequency', ...
    'NumberTitle','off');

bar(frequency);

xticks(1:length(symbols));
xticklabels(cellstr(symbols));

xlabel('Character');
ylabel('Frequency');

title('Character Frequency Analysis');

grid on;

%% ================================================================
% GRAPH 2 - CODE LENGTH
% ================================================================

figure( ...
    'Name','Shannon-Fano Code Length', ...
    'NumberTitle','off');

bar(codeLengths);

xticks(1:length(symbols));
xticklabels(cellstr(symbols));

xlabel('Character');
ylabel('Code Length (bits)');

title('Shannon-Fano Code Length');

grid on;

%% ================================================================
% GRAPH 3 - FREQUENCY VS CODE LENGTH
% ================================================================

figure( ...
    'Name','Frequency vs Code Length', ...
    'NumberTitle','off');

scatter(frequency,codeLengths,80,'filled');

xlabel('Character Frequency');
ylabel('Code Length (bits)');

title('Frequency vs Shannon-Fano Code Length');

grid on;

%% ================================================================
% NESTED FUNCTION FOR OUTPUT
% ================================================================

    function addLine(text)

        out{end+1,1} = text;

    end

end


% =================================================================
% DISPLAY SPECIAL CHARACTERS
% =================================================================

function result = displaySymbol(symbol)

if symbol == ' '

    result = '[SPACE]';

elseif symbol == sprintf('\t')

    result = '[TAB]';

elseif symbol == sprintf('\n')

    result = '[ENTER]';

else

    result = symbol;

end

end


% =================================================================
% SHANNON-FANO ALGORITHM
% =================================================================

function [codes,partitionText] = ...
    generateShannonFano(symbols,probability,codes,indices,prefix)

partitionText = {};

% ------------------------------------------------
% BASE CASE
% ------------------------------------------------

if length(indices) == 1

    if isempty(prefix)

        codes{indices(1)} = '0';

    else

        codes{indices(1)} = prefix;

    end

    partitionText{end+1} = sprintf( ...
        'Symbol %s -> Code %s', ...
        displaySymbol(symbols(indices(1))), ...
        codes{indices(1)});

    return;

end

% ------------------------------------------------
% TOTAL PROBABILITY
% ------------------------------------------------

totalProbability = sum(probability(indices));

% ------------------------------------------------
% FIND BEST SPLIT
% ------------------------------------------------

bestSplit = 1;
bestDifference = inf;

for split = 1:(length(indices)-1)

    group1 = indices(1:split);
    group2 = indices(split+1:end);

    probability1 = sum(probability(group1));
    probability2 = sum(probability(group2));

    difference = abs(probability1-probability2);

    if difference < bestDifference

        bestDifference = difference;
        bestSplit = split;

    end

end

group1 = indices(1:bestSplit);
group2 = indices(bestSplit+1:end);

probability1 = sum(probability(group1));
probability2 = sum(probability(group2));

% ------------------------------------------------
% DISPLAY PARTITION
% ------------------------------------------------

partitionText{end+1} = '';
partitionText{end+1} = ...
    sprintf('Current Group Total Probability = %.6f', ...
    totalProbability);

partitionText{end+1} = ...
    sprintf('Group 1 Probability = %.6f -> bit 0', ...
    probability1);

partitionText{end+1} = ...
    sprintf('Group 2 Probability = %.6f -> bit 1', ...
    probability2);

partitionText{end+1} = 'Group 1 Symbols:';

groupText = '';

for k = 1:length(group1)

    groupText = [groupText ...
        displaySymbol(symbols(group1(k))) ' '];

end

partitionText{end+1} = groupText;

partitionText{end+1} = 'Group 2 Symbols:';

groupText = '';

for k = 1:length(group2)

    groupText = [groupText ...
        displaySymbol(symbols(group2(k))) ' '];

end

partitionText{end+1} = groupText;

% ------------------------------------------------
% RECURSION
% ------------------------------------------------

[codes,text1] = generateShannonFano( ...
    symbols,probability,codes,group1,[prefix '0']);

[codes,text2] = generateShannonFano( ...
    symbols,probability,codes,group2,[prefix '1']);

partitionText = [partitionText text1 text2];

end