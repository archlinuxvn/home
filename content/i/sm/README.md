# INTRODUCTION

`n0b0dy` often uses some smilies from foreign forum.
We need a simple smilies support.

# FETCH LIST OF SMILIES

The following script was used to fetch all smilies from known posts.
This script is provided here for educational purpose. :adore:
You should not run this script again.

<pre>
grep gif ../ -R \
| ruby -e 'STDIN.readlines.each {|l|
    l.scan(%r{(http://[^ ]+)\b}) {|m|
      puts m} }' \
| sort -u \
| while read _uri; do
   wget $_uri;
  done

for f in *.gif; do
  echo mv "$f" "$(echo $f | sed -e "s#^[0-9]cool_##g")"
done
</pre>
