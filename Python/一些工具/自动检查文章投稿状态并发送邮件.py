import re
import os
import smtplib

from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.mime.application import MIMEApplication


class Journal(object):
    def __init__(self, account, password, journal_name):
        self.account = account
        self.password = password
        self.journal_name = journal_name

    def write_log(self, info):
        with open(self.journal_name, "a") as f:
            f.write("%s\n" % info)

    @property
    def read_last_log(self):
        if os.path.exists(self.journal_name):
            with open(self.journal_name, 'r') as f:
                lines = f.readlines()
                last_line = lines[-1]
            return last_line
        else:
            return "newfile"

    def send_info(self, info):
        if self.read_last_log == "%s\n" % info:
            pass
        else:
            days = info.split(',')[0]
            status = info.split(',')[1].lstrip().rstrip()

            context = "This is the %s days since I have submited my manuscript. The status is %s." % (days, status)

            msg = MIMEMultipart()
            msg.attach(MIMEText(context))

            msg['from'] = 'your mail here'
            msg['subject'] = 'My manuscript status'

            msgto = 'your target mail address here'

            try:
                server = smtplib.SMTP()
                server.connect('smtp.163.com')
                server.login('your mail here','your password here')
                server.sendmail(msg['from'], msgto, msg.as_string())
                server.quit()
            except Exception as e:
                print(e)


class JGR(Journal):
    def __init__(self, account, password):
        # if this script is run on a server, then phantomjs is suggested than chrome
        self.driver = webdriver.Chrome()
        self.journal_name = "JGR"
        super(JGR, self).__init__(account=account, password=password, journal_name="JGR")

    @property
    def home_url(self):
        return "https://jgr-atmospheres-submit.agu.org/cgi-bin/main.plex"

    def login(self):
        try:
            self.driver.get(self.home_url)
            if "Journal of Geophysical Research" not in self.driver.title:
                raise Exception('The URL of JGR is not correct!')

            # fill the account
            elem = self.driver.find_element_by_name("login")
            elem.clear()
            elem.send_keys(self.account)

            # fill the password
            elem = self.driver.find_element_by_name("password")
            elem.clear()
            elem.send_keys(self.password)

            elem.send_keys(Keys.RETURN)
        except Exception as e:
            print("JGR login failed: \n")
            print(e)

    def check(self):
        elem = self.driver.find_element_by_partial_link_text('Live Manuscripts')
        elem.click()

        # find how many days past since my submission
        elem = self.driver.find_element_by_partial_link_text('Check Status')
        days = re.findall(re.compile(r'Check Status # .* [0-9]* days',re.M), self.driver.page_source)[0].split()[4]
        elem.click()

        status = re.findall(re.compile(r'Current Stage.*',re.M), self.driver.page_source)[0][26:-10]
        self.driver.close()

        info = "%s, %s" % (days, status)

        self.write_log(info)

        self.send_info(info)




if __name__ == "__main__":
    MS = JGR("your_mail_here", "your_password_here")
    MS.login()
    MS.check()