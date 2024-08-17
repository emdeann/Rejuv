from upload_save import *

def main():
    save_backup()
    service = api_login()
    download_latest_backup(service)
    
if __name__ == '__main__':
    main()

