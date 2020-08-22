[33m30f95a5ec4b6f502a34f27c603a8d61c00eae239[m[33m ([m[1;36mHEAD -> [m[1;32mmaster[m[33m)[m ''
[1mdiff --git a/config.json b/config.json[m
[1mnew file mode 100644[m
[1mindex 0000000..e1d29c7[m
[1m--- /dev/null[m
[1m+++ b/config.json[m
[36m@@ -0,0 +1 @@[m
[32m+[m[32m{"token": "your token", "group_id": "your group id", "posting_speed": 1728, "posted": ""}[m
\ No newline at end of file[m
[1mdiff --git a/manual/XXKrAG8YzZo.jpg b/manual/XXKrAG8YzZo.jpg[m
[1mnew file mode 100644[m
[1mindex 0000000..385eecb[m
Binary files /dev/null and b/manual/XXKrAG8YzZo.jpg differ
[1mdiff --git a/readme.txt b/readme.txt[m
[1mnew file mode 100644[m
[1mindex 0000000..04139a5[m
[1m--- /dev/null[m
[1m+++ b/readme.txt[m
[36m@@ -0,0 +1,8 @@[m
[32m+[m[32mИзображения берутся из папки manual.[m
[32m+[m[32mСкрипт постит изображение в группе вконтакте.[m
[32m+[m
[32m+[m[32m1 пост раз в ~30 минут (1728 секунд).[m
[32m+[m[32mВ сутки выходит 50 постов. Как раз ограничение вк.[m
[32m+[m
[32m+[m[32mЗапуск из powershell в папке[m
[32m+[m[32mpythonw .\script.py[m
\ No newline at end of file[m
[1mdiff --git a/script.py b/script.py[m
[1mnew file mode 100644[m
[1mindex 0000000..9f1b22f[m
[1m--- /dev/null[m
[1m+++ b/script.py[m
[36m@@ -0,0 +1,52 @@[m
[32m+[m[32mfrom os import walk[m
[32m+[m[32mfrom time import time, sleep[m
[32m+[m[32mimport vk[m
[32m+[m[32mimport json[m
[32m+[m[32mimport requests[m
[32m+[m
[32m+[m[32m# set variables[m
[32m+[m[32mwith open('config.json') as cfg:[m
[32m+[m	[32mconfig = json.load(cfg)[m
[32m+[m
[32m+[m[32mtoken = config['token'][m
[32m+[m[32mgroup_id = config['group_id'][m
[32m+[m[32mposted = config['posted'][m
[32m+[m[32mposting_speed = config['posting_speed'][m
[32m+[m[32mimg_path = 'manual/'[m
[32m+[m
[32m+[m[32mdef post(img):[m
[32m+[m[32m    session = vk.Session(access_token=token)[m
[32m+[m[32m    api = vk.API(session, v='6.85')[m
[32m+[m
[32m+[m[32m    upload_url = api.photos.getWallUploadServer(group_id=group_id)['upload_url'][m
[32m+[m[32m    request = requests.post(upload_url, files={'photo': open(img_path + img, "rb")})[m
[32m+[m[32m    params = {'server': request.json()['server'],[m
[32m+[m[32m          'photo': request.json()['photo'],[m
[32m+[m[32m          'hash': request.json()['hash'],[m
[32m+[m[32m          'group_id': group_id}[m
[32m+[m
[32m+[m[32m    data = api.photos.saveWallPhoto(**params)[m
[32m+[m[32m    photo_id = data[0]['id'][m
[32m+[m[32m    attachments = {'photo' + str(data[0]['owner_id']) + '_' + str(photo_id)}[m
[32m+[m
[32m+[m[32m    params = {'attachments' : attachments,[m
[32m+[m[32m          'message': '',[m
[32m+[m[32m          'owner_id': '-' + group_id,[m
[32m+[m[32m          'from_group' : '1'}[m
[32m+[m
[32m+[m[32m    print(api.wall.post(**params))[m
[32m+[m
[32m+[m
[32m+[m[32m# auto posting[m
[32m+[m[32mwhile True:[m
[32m+[m[32m    dir = walk(img_path)[m
[32m+[m[32m    for address, dirs, files in dir:[m
[32m+[m[32m        for img in files:[m
[32m+[m[32m            if img not in posted:[m
[32m+[m[32m                posted += img + ';'[m
[32m+[m[32m                config['posted'] = posted[m
[32m+[m[32m                with open('config.json', 'w') as cfg:[m
[32m+[m[32m                    json.dump(config, cfg)[m
[32m+[m[32m                post(img)[m
[32m+[m[32m                sleep(posting_speed)[m
[32m+[m[41m                [m
\ No newline at end of file[m
