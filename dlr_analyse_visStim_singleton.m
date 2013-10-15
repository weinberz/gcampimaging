%created by Dario Ringach, used in Kuhlman Nature 2013 to analyze data aquired by Elaine Tring at UCLA. Modified July2013 sk
%see readme txt file in this folder
%Data aquired using ScanImage
%Currently requires 256x256 tiff images.  Interpolate to resize if
%necessary.
function [r] = dlr_analyse_visStim(varargin)
originaldirectory=pwd;

genFigures=1;
numTrials = 4;

r = load_image_with_visStim;

if nargin == 0
    %select cells for analysis across trials
    [~, ~,x] = cpselect_sk(r.fuse,r.CSma, 'Wait',true); %modified toolbox cpselect so outputs ALL cells, not just pairs
    % imcontrast(gca)  %possible to incorperate imcontrast to adjust image contrast
    r.basePoints = round(x.basePoints);
    r.basePoints = round(x.basePoints);
else
    r.basePoints = varargin{1}
    r.basePoints = r.basePoints
end

% generate mask from image
r.CSmsk = generate_CS_mask(r);

% now pull the signals out...
r.CSsig = generate_CS_signal_map(r)

%generate figure that labels cells

[r.stimOnsets, ...
r.stimOffsets, ...
r.baseline, ...
r.visStimParamFile, ...
r.vsParamFilename, ...
r.stimOrder, ...
r.stimulusParameters, ...
r.stimOrderIndex, ...
r.responseOrdered_MeanAmplitude, ...
r.responseOrdered_localBaseline, ...
r.responseOrdered_Traces] = calculate_data(r);

% %plot raw fluorescence traces for each cell:

if genFigures
    generate_labeled_figure(r);
    generate_onsets_figure(r);
    generate_raw_fluorescence_figure(r)
    generate_ordered_fluorescence_figure(r)
end % if genFigures

mkdir('Analysis');
cd ('Analysis');
indexUS= strfind(r.f, '_');
indexUS_last=indexUS(end);
filenameprefix1= r.f(1:indexUS_last+3);
contrastStrValue= [num2str(r.visStimParamFile.contrast*100)];
sf = [filenameprefix1 '-' contrastStrValue];

[sf,sp]= uiputfile('.mat', ['Save responses for image file: ' filenameprefix1], sf);
save(sf,'r');

cd (originaldirectory);








