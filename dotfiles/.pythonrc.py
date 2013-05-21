# run these on python shell startup
from datetime import datetime, date, time, timedelta
try:
    import readline
except ImportError:
    print("Module readline not available.")
else:
    import rlcompleter
    readline.parse_and_bind("tab: complete")

try:
    import editrepl
except ImportError:
    print("Module editrepl not available.")
