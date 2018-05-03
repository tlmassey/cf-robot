function img = correctLighting(img, method)
    addpath(genpath('../'));


    if nargin<2, method='rgb'; end
    switch lower(method)
        case 'rgb'
            %# process R,G,B channels separately
            for i=1:size(img,3)
                img(:,:,i) = LinearShading( img(:,:,i) );
            end
        case 'hsv'
            %# process intensity component of HSV, then convert back to RGB
            HSV = rgb2hsv(img);
            HSV(:,:,3) = LinearShading( HSV(:,:,3) );
            img = hsv2rgb(HSV);
        case 'lab'
            %# process luminosity layer of L*a*b*, then convert back to RGB
            LAB = applycform(img, makecform('srgb2lab'));
            LAB(:,:,1) = LinearShading( LAB(:,:,1) ./ 100 ) * 100;
            img = applycform(LAB, makecform('lab2srgb'));
    end
end
