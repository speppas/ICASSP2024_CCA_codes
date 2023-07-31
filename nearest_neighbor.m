function [ detected ] = nearest_neighbor( labels, samples )
%NEAREST_NEIGHBOR assigns samples to labels using the nearest neighbor
%algorithm.
%labels, samples and detected are column vectors of complex numbers

% If the dimensions of data differ, then return
if size( labels ) ~= size( samples  )
    fprintf('Input sizes do not agree\n')
    return
end

% Number of samples
N = size( samples, 1 );

% Number of labels
n_labels = size( labels, 1 );

% Array that holds the distance of each point from each label
distances = zeros( n_labels, 1 );

% Initialize detected array
detected = zeros( N, 1 );

% Iterate all samples
for ii=1:N
    % Iterate all labels and calculate the distance of each sample from
    % each label
    for jj=1:n_labels
        distances(jj) = norm( labels( jj ) - samples( ii ) );
    end
    
    % index of minimum distance
    [~, min_idx] = min( distances );
    
    % detected symbol
    detected( ii ) = labels( min_idx );
end

    
end
