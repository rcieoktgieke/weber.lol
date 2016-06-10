###
# Page options, layouts, aliases and proxies
###
require "rmagick"

GALLERY_FOLDER = "gallery"
THUMBS_FOLDER = "thumbs"
TOTAL_WIDTH = 960
IMAGES_PER_ROW = 5
IMAGE_MARGINS = 10
WIDTH_ADJUSTMENT = 2.0 #to account for rounding

gallery = []
filenames = Dir.entries("source/images/" + GALLERY_FOLDER).select {|filename| filename != "." and filename != ".." and filename != THUMBS_FOLDER }

index = 0
while index + IMAGES_PER_ROW <= filenames.length do
  minHeight = nil
  for i in index..index + IMAGES_PER_ROW - 1
    filename = filenames[i]
    currentImage = Magick::ImageList.new("source/images/" + GALLERY_FOLDER + "/" + filename)
    currentHeight = currentImage.first.rows
    minHeight = currentHeight if (minHeight == nil or currentHeight < minHeight)
  end

  width = 0.0
  for i in index..index + IMAGES_PER_ROW - 1
    filename = filenames[i]
    currentImage = Magick::ImageList.new("source/images/" + GALLERY_FOLDER + "/" + filename)
    currentWidth = currentImage.first.columns
    currentHeight = currentImage.first.rows
    width += currentWidth * minHeight/currentHeight 
  end

  imagesToAdd = 0
  while width < TOTAL_WIDTH
    imagesToAdd += 1
    filename = filenames[index + IMAGES_PER_ROW + imagesToAdd]
    currentImage = Magick::ImageList.new("source/images/" + GALLERY_FOLDER + "/" + filename)
    currentWidth = currentImage.first.columns
    currentHeight = currentImage.first.rows
    width += currentWidth * minHeight/currentHeight 
  end

  widthRatio = (TOTAL_WIDTH - WIDTH_ADJUSTMENT - (IMAGES_PER_ROW + imagesToAdd - 1) * IMAGE_MARGINS)/width

  row = []
  for i in index..index + IMAGES_PER_ROW + imagesToAdd - 1
    filename = filenames[i]
    currentImage = Magick::ImageList.new("source/images/" + GALLERY_FOLDER + "/" + filename)
    currentHeight = currentImage.first.rows
    scaleRatio = widthRatio * minHeight/currentHeight
    thumbnail = currentImage.scale(scaleRatio)
    thumbnail.write("source/images/" + GALLERY_FOLDER + "/" + THUMBS_FOLDER + "/" + filename)
    row.push(filename)
  end
  gallery.push(row)

  index = index + IMAGES_PER_ROW + imagesToAdd
end

if index < filenames.length
  for i in index..filenames.length - 1
    filename = filenames[i]
    currentImage = Magick::ImageList.new("source/images/" + GALLERY_FOLDER + "/" + filename)
    currentHeight = currentImage.first.rows
    minHeight = currentHeight if (minHeight == nil or currentHeight < minHeight)
  end

  width = 0.0
  for i in index..filenames.length - 1
    filename = filenames[i]
    currentImage = Magick::ImageList.new("source/images/" + GALLERY_FOLDER + "/" + filename)
    currentWidth = currentImage.first.columns
    currentHeight = currentImage.first.rows
    width += currentWidth * minHeight/currentHeight
  end

  widthRatio = (TOTAL_WIDTH - WIDTH_ADJUSTMENT - (filenames.length - index - 1) * IMAGE_MARGINS)/width

  row = []
  for i in index..filenames.length - 1
    filename = filenames[i]
    currentImage = Magick::ImageList.new("source/images/" + GALLERY_FOLDER + "/" + filename)
    currentHeight = currentImage.first.rows
    scaleRatio = widthRatio * minHeight/currentHeight
    thumbnail = currentImage.scale(scaleRatio)
    thumbnail.write("source/images/" + GALLERY_FOLDER + "/" + THUMBS_FOLDER + "/" + filename)
    row.push(filename)
  end
  gallery.push(row)
end

gallery.each do |row|
  row.each do |filename|
    puts filename
  end
end

configure :build do
  config[:gallery] = gallery
  config[:GALLERY_FOLDER] = GALLERY_FOLDER
  config[:THUMBS_FOLDER] = THUMBS_FOLDER
  config[:GALLERY_WIDTH] = TOTAL_WIDTH
  config[:IMAGE_MARGINS] = IMAGE_MARGINS
end

# Per-page layout changes:
#
# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# With alternative layout
# page "/path/to/file.html", layout: :otherlayout

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

# General configuration

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
end

###
# Helpers
###

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

helpers do
  def get_gallery
    return @gallery
  end
end 

# Build-specific configuration
configure :build do
  # Minify CSS on build
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript
end
