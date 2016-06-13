#This is the Middleman config file. The only changes are in the first handful of lines. 

###
# Page options, layouts, aliases and proxies
###

require "curtiss_image_process.rb" #This imports the Curtiss's image processing script

set :relative_links, true #This tells Middleman to make all links relative. This is useful when deploying your page to any location other than the root of your filesystem, so I turned it on.

gallery = [] #This will become a matrix of filenames, where a row in the matrix represents a row in the gallery, and each element is the filename of the appropriate image.
GALLERY_FOLDER = "gallery" #This is the name of the folder (or path to the folder) where all images to be processed and used by Curtiss will be stored.
THUMBS_FOLDER = "thumbs" #This is the name of the folder witihin the GALLERY_FOLDER folder where thumbnails will be saved.
TOTAL_WIDTH = 960 #This is the width (in pixel) which Curtiss will make each row fit within. It also sets a number of style attributes from elsewhere in Middleman, where it is accessed by the config[:TOTAL_WIDTH] variable (see below).
IMAGES_PER_ROW = 4 #This is the number of images Curtiss will attempt to place on each row. If the imagesprocessed are not wide enough, it will add to this number until it fills the row. This is also accessed elsewhere in Middleman.
IMAGE_MARGINS = 10 #This is the number of pixels Curtiss will leave for margins BETWEEN images. It accounts for no margins around the gallery as a whole. It subtracts the number of pixels for margins times the ACTUAL number of images in the row (can be different than IMAGES_PER_ROW, as discussed above) from the TOTAL_WIDTH, and scales images in each row to fit that calculated width.
WIDTH_ADJUSTMENT = 2.0 #This is a number of pixels left blank on each row by default. Try adjusting this if images are wrapping before the end of their rows. The reason for this wiggle room is because pixel counts must be integers, and when rounding from the calculations used to scale images, there is a possibility of more pixels in a row than the TOTAL_WIDTH.
OVERLAY_THUMB_HEIGHT = 100 #This is the height of the list of thumbnails used in the overlay. This is not actually used by the image processing script, but it is the only other cofigurable variable used by the front end.

curtiss_init(gallery, GALLERY_FOLDER, THUMBS_FOLDER, TOTAL_WIDTH, IMAGES_PER_ROW, IMAGE_MARGINS, WIDTH_ADJUSTMENT) #This function wraps the entirety of the curtiss_image_process.rb script. The only effect is has on the rest of this script is by initializing the gallery matrix.

configure :build do #This is Middleman's method of passing variable from this script to the rest of the project. In the front end source code, the following will be accessed in this format: config[:VARIABLE_NAME].
  config[:gallery] = gallery
  config[:GALLERY_FOLDER] = GALLERY_FOLDER
  config[:THUMBS_FOLDER] = THUMBS_FOLDER
  config[:GALLERY_WIDTH] = TOTAL_WIDTH
  config[:IMAGE_MARGINS] = IMAGE_MARGINS
  config[:WIDTH_ADJUSTMENT] = WIDTH_ADJUSTMENT
  config[:OVERLAY_THUMB_HEIGHT] = OVERLAY_THUMB_HEIGHT
end

#No further details in this file differ from the default created by Middleman... I think.

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

# Build-specific configuration
configure :build do
  # Minify CSS on build
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript
end
