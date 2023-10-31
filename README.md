# Git Stats with code maat

## Table of Contents

- [Git Stats with code maat](#git-stats-with-code-maat)
  - [Table of Contents](#table-of-contents)
  - [การติดตั้ง maat command](#การติดตั้ง-maat-command)
  - [xlog-with-merge](#xlog-with-merge)
  - [การใช้งานแบบ ไม่ Setup maat command](#การใช้งานแบบ-ไม่-setup-maat-command)
    - [Git log](#git-log)
    - [Run code maat](#run-code-maat)
    - [Complexity and Frequency in Git](#complexity-and-frequency-in-git)

---

## การติดตั้ง maat command

เพื่ออำนวยความสะดวกในการใช้งาน เราสามารถสร้าง Command ของ code-maat ได้ดังนี้

เนื่องจากผมกำหนดแบบไฟล์ Bin ไว้ เพื่อไม่ลดความยุ่งยากในการกำหนด Path บนระบบ

1. Copy โฟล์เดอร์ bin ไว้ที่เครื่อง ของผมจะไว้ที่ `/Users/Username`
2. เข้าไปที่โฟล์เดอร์ Bin
   ```bash
   cd bin
   ```
3. เปลี่ยน Permission 
   ```bash
   chmod +x maat
   ```

   ```bash
   chmod +x merge
   ```
4. สร้างหรือเปิดไฟล์ .zprofile หรือ .bashrc หรือ .bash_profile (ผมใช้ .zprofile)
   ```bash
      vi .zprofile
   ```
5. กำหนด Path ใน .zprofile
   ```bash
      export PATH="$PATH:$HOME/Bin"
   ```
6. Restart หรือ ปิด-เปิด Terminal ใหม่

เท่านี้ก็สามารถใช้งาน code-maat ได้แล้ว โดยใช้คำสั่ง ```maat``` แทนการเรียกใช้แบบ ```java -jar``` ไฟล์

```bash
maat -h
```

---

## xlog-with-merge

เป็นไฟล์ Shell Script ที่เป็นชุดคำสั่งใช้ในการเรียกใช้งาน maat และ Merge csv ที่ทำขึ้นมาเพื่อความสะดวก

```bash
bash xlog-with-merge.sh before(YYYY-MM-DD) after(YYYY-MM-DD) : xlog 2018-10-21 2018-01-21"
```

ตัวอย่าง

```bash
bash xlog-with-merge.sh 2023-10-21 2023-01-21
```

---

## การใช้งานแบบ ไม่ Setup maat command

คำสั่งในการดึงข้อมูลจาก Git และนำมาสร้างเป็น Report ด้วย Code-maat

### Git log

```sh
git log --numstat
```

```sh
git log --all --numstat --date=short --pretty=format:'--%h--%ad--%aN' --no-renames --after=YYYY-MM-DD --before=YYYY-MM-DD > logfile.log
```

- git legacy

  ```sh
  git log --pretty=format:'[%h] %aN %ad %s' --date=short --numstat --after=YYYY-MM-DD > logfile.log
  ```

### Run code maat

1. Help

   ```sh
   java -jar code-maat-1.1-SNAPSHOT-standalone.jar -h
   ```

2. Analysis Options `-a, --analysis`

   abs-churn, age, author-churn, authors, communication, coupling, entity-churn, entity-effort, entity-ownership, fragmentation, identity, main-dev, main-dev-by-revs, messages, refactoring-main-dev, revisions, soc, summary

   - example

     ```sh
     java -jar code-maat-1.1-SNAPSHOT-standalone.jar -l logfile.log -c git2 -a authors
     ```

3. Run Code Maat

   1. Summary Data

      ```sh
      java -jar code-maat-1.1-SNAPSHOT-standalone.jar -l logfile.log -c git2 -a summary
      ```

   2. Analyze Change Frequencies

      ```sh
      java -jar code-maat-1.1-SNAPSHOT-standalone.jar -l logfile.log -c git2 -a revisions
      ```

   3. Calculate code age

      ```sh
      java -jar code-maat-1.1-SNAPSHOT-standalone.jar -l logfile.log -c git2 -a age
      ```

   4. Mining logical coupling

      ```sh
      java -jar code-maat-1.1-SNAPSHOT-standalone.jar -l logfile.log -c git2 -a coupling
      ```

   5. Code churn measures

      ```sh
      java -jar code-maat-1.1-SNAPSHOT-standalone.jar -l logfile.log -c git2 -a abs-churn
      ```

   6. churn by author

      ```sh
      java -jar code-maat-1.1-SNAPSHOT-standalone.jar -l logfile.log -c git2 -a author-churn
      ```

   7. churn by entity

      ```sh
      java -jar code-maat-1.1-SNAPSHOT-standalone.jar -l logfile.log -c git2 -a entity-churn
      ```

   8. entity ownership

      ```sh
      java -jar code-maat-1.1-SNAPSHOT-standalone.jar -l logfile.log -c git2 -a entity-ownership
      ```

   9. entity effort

      ```sh
      java -jar code-maat-1.1-SNAPSHOT-standalone.jar -l logfile.log -c git2 -a entity-effort
      ```

   10. main developer

       ```sh
       java -jar code-maat-1.1-SNAPSHOT-standalone.jar -l logfile.log -c git2 -a main-dev
       ```

---

### Complexity and Frequency in Git

1. Analyze `revisions` from `logfile.log`

   ```sh
   java -jar code-maat-1.1-SNAPSHOT-standalone.jar -l logfile.log -c git2 -a revisions > revisions.csv
   ```

2. Analyze line of code with `cloc`

   - nodejs

     ```sh
     cloc ./ --by-file --csv --quiet --exclude-dir=node_modules --report-file=./lines.csv
     ```

   - .NetCore

     ```sh
     cloc ./ --by-file --csv --quiet --exclude-dir=bin,obj --report-file=./lines.csv
     ```

3. Analyze `complexity` and `frequency` with `merge_comp_freqs.py`

   ```sh
   python3 merge_comp_freqs.py revisions.csv lines.csv > comp-freqs.csv
   ```

---

Ref: [code maat](https://github.com/adamtornhill/code-maat)
