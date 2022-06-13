using ImageFiltering

lines = readlines("input")

image_enhancement = BitVector(collect(lines[1]) .== '#')
image = BitArray(hcat(collect.(lines[3:end])...) .== '#')
image = padarray(image, Fill(0, (5, 5)))

kernel = centered([1<<8 1<<7 1<<6; 1<<5 1<<4 1<<3; 1<<2 1<<1 1<<0]')

for i = 1:2
    map!(x->image_enhancement[x+1], image, imfilter(image, kernel))
end

display(count(image))

image = padarray(image, Fill(0, (95, 95)))

for i = 3:50
    map!(x->image_enhancement[x+1], image, imfilter(image, kernel))
end

display(count(image))