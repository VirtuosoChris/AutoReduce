pkg load image
#imgIn = imread(argv(){1});
#maxdim = max(size(imgIn));
#img = zeros(maxdim, maxdim, size(imgIn)(3));
#img(1:size(imgIn)(1), 1:size(imgIn)(2), 1:size(imgIn)(3)) = imgIn;

img = imread(argv(){1});

R = img(:,:,1);
G = img(:,:,2);
B = img(:,:,3);

rout = autoreduce(R, .85);
gout = autoreduce(G, .85);
bout = autoreduce(B, .85);

"\noutput dimensions:"
outDims = max(max( size(rout), size(gout) ) , size(bout))

rout = imresize(uint8(rout), outDims);
gout = imresize(uint8(gout), outDims);
bout = imresize(uint8(bout), outDims);

imgout = zeros(outDims(1),outDims(2), 3);

size(imgout)

imgout(:,:,1) = rout;
imgout(:,:,2) = gout;
imgout(:,:,3) = bout;

argv(){1}
imwrite(uint8(imgout),argv(){1}, 'Quality', 100);
