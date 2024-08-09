#handle non square
#handle resampling
#try different color space

function [reduced] = autoreduce(imgIn, thresh)
	
	#img_f = fftshift(fft2(im2double(imgIn))); ##fftshift
	img_f = (dct2((imgIn))); ##fftshift

	img_f_abs = abs(img_f);
	
	dims = size(img_f);

	if length(dims) == 3
		channels = size(img_f)(3);
	else 
		channels = 1;

	end
		
	#get the total energy in the image.  should be of length channels
	magnitude = sum(sum(img_f_abs));
	
	#todo take into account rectangular images
	dimBounds = min(dims(1), dims(2));
	
	#how many pixels along the max axis will we take per pixel on the min axis? 
	aspect = max(dims(1), dims(2)) / dimBounds;
	
	if dims(1) > dims(2)
		aspectVec = [aspect,1.0];
	else
		aspectVec = [1.0, aspect];
	end
	
	centertmp = (dims./2);

	center = [floor(centertmp(1)), floor(centertmp(2))];
	
	
	aspectVec
	
	for i = 1 : dimBounds-1 
		
		pixelsToTake = [i-1,i-1] .* aspectVec;
		
		minCoords = [1,1];#center .- [floor(i/2),floor(i/2)];
		##minCoords = center .- [floor(i/2),floor(i/2)];
		minCoords = max(minCoords,1);
		
        maxCoords = minCoords.+pixelsToTake;

		subImg = img_f_abs( minCoords(1):maxCoords(1), minCoords(2):maxCoords(2) );
	
		sub_sum = sum(sum(subImg));
				
		#magnitude
		ratio = sub_sum ./ magnitude;
		
		#min(ratio)
		
		if min(ratio) >= thresh
				
			#reduced_f = img_f(minCoords(1):pixelsToTake(1),minCoords(2):pixelsToTake(2),:);
			
			reduced_f = img_f(minCoords(1):maxCoords(1),minCoords(2):maxCoords(2),:);
		
			reduced =  (idct2(reduced_f));
			
			scaled_dims = size(reduced)
			mean_scaled = sum(sum(reduced,2),1) ./ (scaled_dims(1) * scaled_dims(2))
			
			#myAverage * scale = oldAverage
			#scale = oldAverage / myAverage
			
			image_mean = sum(sum(imgIn)) / (dims(1)*dims(2));
			
			scaleFactor = image_mean./mean_scaled;
			reduced .*= scaleFactor; 
			
			#sum(sum(reduced,2),1) ./ (scaled_dims(1) * scaled_dims(2))
			
			size(reduced)
			
			return;
		end
		
	end
	
	reduced = imgIn;
	
end