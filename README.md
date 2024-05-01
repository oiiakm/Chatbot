# Chat App
Chat app is a flutter application that utilizes the OpenAI API to provide responses to user queries. The main feature of the application will be a text box where users can input their queries, and upon submission, the app will fetch responses from OpenAI and display them to the user.

## Brief Guide to make this project

### Setup the project
This project is small so I am using the getx state management and MVVM architecture for separating the UI and bussiness logic.
Create a new Flutter project
```bash
flutter create chat_app
```
Add the `http` and `get` Package to the `pubspec.yaml` file

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^0.13.3
  get: ^4.6.6
  ```

### Design User Interface (UI)
Created  a animated background using the build in animation and canvas in flutter which has a circular small ball distributed across the screen with random movement.
Designed the text box and send icon where user can enter and chat with the AI.

### Integrate OpenAI API
First of all create a account and login,now visit to API keys and get the secret key.Now visit the documentation for implementing the API.
```bash
https://platform.openai.com/docs/api-reference/chat/create
```
Here is the detail documentation for using the API for different models.Let's understand this in brief for this chat app.

HTTP POST request to the OpenAI API endpoint for generating chat completions using the GPT-3.5 model
```bash
final response = await http.post(
          Uri.parse('https://api.openai.com/v1/chat/completions'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apiKey',
          },
          body: jsonEncode({
            "model": "gpt-3.5-turbo",
            "messages": [
              {"role": "user", "content": message}
            ],
            "temperature": 0.3
          }),
        );
```
`Note`: Don't forget to check the response status and return the error occurs.
Now let's get the data which is in the form of json and decode it using `jsonDecode` and extract the message received from the model.
```bash
final data = jsonDecode(response.body);
final aiResponse = data['choices'][0]['message']['content'].trim();
```
Add this data to a list to show it into the UI of the app.

### Implement Error Handling
Now I have implemented the handing of any error using try-catch block and show to the user using the snackbar.Look at the sample code for the snackbar.
```
void displayErrorMessage(String errorName, String errorMessage) {
    Get.snackbar(
      errorName,
      errorMessage,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      borderRadius: 10.0,
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      animationDuration: const Duration(milliseconds: 400),
      snackStyle: SnackStyle.FLOATING,
      duration: const Duration(seconds: 4),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      mainButton: TextButton(
        onPressed: () {
          Get.back();
        },
        child: const Text(
          'OK',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
```
### Testing and Debugging
Now after or while building the app use the widget inspector to look out any issues in the widgets,use many print statements in order get the output in the debug consol and also try to dispose any controller if used in the app.After building the complete app run it on the real device by generating the release apk ,using the command
```
flutter build apk --release
```

