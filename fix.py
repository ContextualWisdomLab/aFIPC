import re

with open("R/aFIPC.R", "r") as f:
    content = f.read()

# Instead of asking, just assume yes/no based on the function?
# Let's see what happens if we just remove the interactive parts and assume default parameters, or pass warnings.
