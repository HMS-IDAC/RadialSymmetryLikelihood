function writeFloatImageToTiffFile(Image,filepath)
    t = Tiff(filepath,'w');
    t.setTag('Photometric',Tiff.Photometric.MinIsBlack); % assume grayscale
    t.setTag('BitsPerSample',32);
    t.setTag('SamplesPerPixel',1);
    t.setTag('SampleFormat',Tiff.SampleFormat.IEEEFP);
    t.setTag('ImageLength',size(Image,1));
    t.setTag('ImageWidth',size(Image,2));
    t.setTag('PlanarConfiguration',Tiff.PlanarConfiguration.Chunky);
    t.write(Image);
    t.close();
end