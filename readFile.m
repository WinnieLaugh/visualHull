function b = readFile(filename)

a = imread(filename);

imshow(a);

b = rgb2gray(a);

figure;
imshow(b);

            



