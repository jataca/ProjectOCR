from __future__ import print_function
import httplib2
import sys, os

from apiclient import discovery
from apiclient import errors
from oauth2client import client
from oauth2client import tools
from oauth2client.file import Storage
import base64
import email

# If modifying these scopes, delete your previously saved credentials
# at ~/.credentials/gmail-python-quickstart.json
SCOPES = 'https://www.googleapis.com/auth/gmail.readonly'
CLIENT_SECRET_FILE = 'client_secret.json'
APPLICATION_NAME = 'Gmail API Python Quickstart'


"""
	Gets valid user credentials from storage.

    If nothing has been stored, or if the stored credentials are invalid,
    the OAuth2 flow is completed to obtain the new credentials.

    Returns:
        Credentials, the obtained credential.
"""
def get_credentials():

    home_dir = os.path.expanduser('~')
    credential_dir = os.path.join(home_dir, '.credentials')
    if not os.path.exists(credential_dir):
        os.makedirs(credential_dir)
    credential_path = os.path.join(credential_dir,
                                   'gmail-python-quickstart.json')

    store = Storage(credential_path)
    credentials = store.get()
    if not credentials or credentials.invalid:
        flow = client.flow_from_clientsecrets(CLIENT_SECRET_FILE, SCOPES)
        flow.user_agent = APPLICATION_NAME
        if flags:
            credentials = tools.run_flow(flow, store, flags)
        else: # Needed only for compatibility with Python 2.6
            credentials = tools.run(flow, store)
        print('Storing credentials to ' + credential_path)

    return credentials


"""
	Downloads attachments from the most recent email message
 """
def download_attachments(credentials):
    http = credentials.authorize(httplib2.Http())
    service = discovery.build('gmail', 'v1', http=http)

    results = service.users().labels().list(userId='hwb.test1@gmail.com').execute()
    labels = results.get('labels', [])

    response = service.users().messages().list(userId='me', labelIds='INBOX').execute()
    messages = []

    if 'messages' in response:
        messages.extend(response['messages'])

    message = service.users().messages().get(userId='me', id=messages[0]['id']).execute()
    msgId = messages[0]['id']

    prefix="" # used for filename if we need it to

    for part in message['payload']['parts']:
        if part['filename']:
            if 'data' in part['body']:
                data=part['body']['data']
            else:
                attId=part['body']['attachmentId']
                att=service.users().messages().attachments().get(userId='me', messageId=msgId,id=attId).execute()
                data=att['data']

            file_data = base64.urlsafe_b64decode(data.encode('UTF-8'))
            path = prefix+part['filename']

            with open(path, 'wb') as f:
                f.write(file_data)

    return path

def run_ocr(filepath):
    #os.system(./ConvertPDFs.sh) # won't work bescause we're in Windows
    return 0


"""
	Shows basic usage of the Gmail API.

    Creates a Gmail API service object and outputs a list of label names
    of the user's Gmail account.
 """
def main():
    credentials = get_credentials()

    filepath = download_attachments(credentials) # THIS METHOD WILL ONLY PROCESS ONE OF THE ATTACHMENTS

    run_ocr(filepath)

if __name__ == '__main__':
    main()
