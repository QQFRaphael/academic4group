# -*- coding=utf-8 -*-
import requests
import itchat
import random

@itchat.msg_register(itchat.content.TEXT)
def tuling_reply(msg):
    defaultReply = '[Auto]'+"祝您新年快乐，万事如意！"
    return defaultReply

itchat.auto_login(enableCmdQR=2)
itchat.run()