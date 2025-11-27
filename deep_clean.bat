@echo off
echo Stopping Gradle Daemons...
cd android
call gradlew --stop
cd ..

echo Cleaning Flutter Project...
call flutter clean

echo Removing Gradle Cache (Local)...
if exist android\.gradle rmdir /s /q android\.gradle

echo Fetching Dependencies...
call flutter pub get

echo Done! Try running 'flutter run' now.
pause
