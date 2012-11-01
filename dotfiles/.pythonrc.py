# run these on python shell startup
from datetime import datetime, date, time, timedelta
try:
    import readline
except ImportError:
    print "Module readline not available."
else:
    import rlcompleter
    readline.parse_and_bind("tab: complete")
