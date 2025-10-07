# Yapping Time [group 1]— README

A simple chat app/web built with Flutte that uses Firebase for login and real-time chats.

---

## Demo & Slides

  🔗 Teaching video: [link](https://www.canva.com/design/DAG0pRnx83c/Ua9qdRTz2TvDAFX5wh4s4w/edit?utm_content=DAG0pRnx83c&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton)  
  🔗 Presentation slides: [link](https://www.canva.com/design/DAG0eTBfnVY/SwMcQ2uFA02FsbP9MhvW4g/edit?utm_content=DAG0eTBfnVY&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton)

---

## New feature: Firebase

- **What it is:** Ready-made backend services from Google.  
- **What we use:**  
  - Authentication → Email/password sign in & sign up.  
  - Cloud Firestore → Store chat rooms and messages (real-time).  
- **Why:** Faster than building a backend from scratch.

---

## How to run this project
```bash
flutter pub get
flutter run  # choose web would be faster
```

---

## Your task is to setup/change the Firebase connection : (video at 01:45–02:32)
1. Clone the git
2. Setup the Firebase account and project first  
   🔗 [Firebase Console](https://firebase.google.com/?gclsrc=aw.ds&gad_source=1&gad_campaignid=20100026061&gbraid=0AAAAADpUDOjruD2U2spJffTEFzLhkVlD8&gclid=Cj0KCQjwrojHBhDdARIsAJdEJ_c98oi8Sa8BVLAY1v1H5ryoTmx6CrjBZe_kP6pdacQBMumMJGMYiVUaArnGEALw_wcB)

3. Setup Firebase code in project:
```bash
1. npm install -g firebase-tools
2. firebase login (no then yes)

if error -> administrator powershall
- get-executionpolicy
- set-executionpolicy remotesigned
- yes

3. for window (mac can skip this part)
firebase projects:list

4. flutter pub global activate flutterfire_cli

5. for mac(window can skip this part)
copy the command you get and run (it will be like export path...)

6. flutterfire configure
(for mac only!! then chose the project you create earlier)

(for window pls use flutterfire configure --project=(project name that we got on the 3 step)-(that project id)
so it wil be like --project=ABCDproject-12redf )

7. flutter pub add firebase_core firebase_auth cloud_firestore
8. flutter pub get
9. flutter run
```

---

## Members

- Member 1 — 622115040 สุชานันท์ ศิริจรรยา 
- Member 2 — 652115041 มัชฌิมา คำยอด 
- Member 3 — 652115048 ศุภรัตน์ แซ่ลี 
- Member 4 — 652115053 หรรษาวัฒน์ หารวรวิรุฬห์  

---

## Notes

- If login fails, check Firebase Authentication is enabled (Email/Password) in Console on website.  

