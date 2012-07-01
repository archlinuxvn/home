# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.

def tags
  if @item[:tags].nil?
    ""
  else
    @item[:tags].join(', ')
  end
end
