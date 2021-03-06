function img = discreteSquare(varargin)
%DISCRETESQUARE Discretize a planar square
%
%   IMG = discreteSquare(DIM, CENTER, SIDE)
%   DIM is the size of image, with the format [x0 dx x1;y0 dy y1]
%   CENTER is the center of the square
%   SIDE is the length of the side of the square.
%
%   IMG = discreteSquare(DIM, CENTER, SIDE, THETA)
%   Also specify spherical angle of the normal of a face of the square.
%   THETA is the angle with the horizontal, in degrees, counted counter-
%   clockwise in direct basis (and clockwise in image basis).
%
%   IMG = discreteSquare(DIM, SQUARE)
%   send parameters in a row vector, where SQUARE contains at least the
%   center coordinate, and possibly the other parameters.
%
%   IMG = discreteSquare(LX, LY, ...);
%   Specifes the pixels coordinates with the two row vectors LX and LY.
%
%   Example
%   img = discreteSquare([1 1 100;1 1 100], [50 50], 30);
%   img = discreteSquare([1 1 100;1 1 100], [50 50 30]);
%   img = discreteSquare([1 1 100;1 1 100], [50 50 30 30]);
%
%   See Also
%   imShapes, discreteDisc, discreteRectangle
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2006-05-16
% Copyright 2006 INRA - CEPIA Nantes - MIAJ (Jouy-en-Josas).

%   HISTORY
%   12/10/2006: typo in the doc
%   04/01/2007: concatenate transforms before applying them
%   19/06/2007: update doc
%   04/03/2009: use meshgrid
%   29/04/2009: update transforms
%   29/05/2009: use more possibilities for specifying grid
%   22/01/2010: fix auto center with odd image size
%   2011-03-30 use degrees

% compute coordinate of image voxels
[lx, ly, varargin] = parseGridArgs(varargin{:});
[x, y]   = meshgrid(lx, ly);

% default parameters
center = [lx(ceil(end/2)) ly(ceil(end/2))];
side    = center;
theta   = 0;

% process input parameters
if length(varargin)==1
    % all paramater in the first argument
    var = varargin{1};
    center = var(:,1:2);
    if size(var, 2)>2
        side = var(:,3);
    end
    if size(var, 2)>3
        theta = var(:,4);
    end
    
elseif ~isempty(varargin)
    % first argument is center, optionnally followed by side length, then
    % by rotation angle
    center = varargin{1};
    if length(varargin)>1
        side = varargin{2};
    end
    if length(varargin)>2
        theta = varargin{3};
    end
end

% For squares, size of sides is the same in all directions
side    = [side(1) side(1)];

% transforms voxels according to square orientation
tra     = createTranslation(-center);
rot     = createRotation(-deg2rad(theta));
sca     = createScaling(1./side);
[x, y]  = transformPoint(x, y, sca*rot*tra);

% create image: simple threshold over 2 dimensions
img = abs(x) <= .5 & abs(y) <= .5;

