#####################
# Libraries
#####################

import os.path
import pandas as pd

#####################
# Variables
#####################

# Config file
configfile: "config/config.yaml"

CHRS  = config["contigs"]
