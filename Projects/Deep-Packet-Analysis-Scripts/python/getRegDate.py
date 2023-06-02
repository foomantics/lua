### Author(s): Jim Lee
### Last Updtaed: 03/26/19
### File Description: Python script to create a WHOIS lookup module
### and return the domain registration date to the Lua API.



import whois as w
import sys

# Given a domain in 2ld format e.g. 'example.com'
# use imported whois module to execute WHOIS lookup
# on this domain and then return the registration date
def dom_date(dom):
   whois_dom = w.whois(dom)
   if whois_dom:
      return str(whois_dom.creation_date)

# Given a domain in 2LD format e.g. 'example.com'
# find the WHOIS registration date, write the
# dom and date to the date lookup file, and then
# return to the caller NetMon DPA
def main():
   if len(sys.argv) < 2:
      print("Error: bad number of arguments, exiting.")

   try:
      dom = sys.argv[1]
      print dom_date(dom)

   except:
      print("Error: bad WHOIS lookup, exiting.")

######### MAIN CHUNK #########
main()
