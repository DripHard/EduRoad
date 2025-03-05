# 📌 EduRoad – Your AI-Powered Learning GPS

🚀 **Welcome to EduRoad!** 🚀

Tired of searching for how to learn a new skill, only to get lost in an endless sea of YouTube videos, Google links, and outdated blogs? 😵‍💫

That's why we built **EduRoad** – an AI-driven app that **guides you step-by-step** on your learning journey. Instead of dumping information, we provide **structured roadmaps** to mastering any skill, saving you time, frustration, and confusion. 💡

---

## 🌟 Why EduRoad?
🔍 **The Problem**  
- Search engines give you **scattered results**, not a structured path. 🌀
- Online courses are great, but they don’t tell you **which ones to take first**. 🤷
- People **quit before they start** because there’s no clear direction. 😔

🎯 **The Solution**  
EduRoad acts as a **learning GPS**, showing you exactly what to study next, in the right order. 

For example, if you want to learn Python, instead of getting overwhelmed, you’ll see:
✅ **Step 1** – Learn the Basics (curated beginner-friendly courses & tutorials)  
✅ **Step 2** – Practice Simple Projects (hands-on exercises recommended by AI)  
✅ **Step 3** – Move to Advanced Topics (AI suggests the best next steps based on progress)  

No guesswork. No wasted time. Just smooth, structured learning. 🛣️✨

---

## 🛠️ Features
📌 **AI-Powered Roadmaps**  
- 🔹 Personalized learning paths for any skill.
- 🔹 AI-curated learning resources (YouTube, articles, online courses).  
- 🔹 Progress tracking with milestone recommendations.  

📌 **B2B Licensing & EdTech Partnerships**  
- 🏢 Companies can license EduRoad for employee upskilling.  
- 📚 EdTech platforms (Udemy, Coursera, LinkedIn Learning) can integrate EduRoad for structured guidance.  

📌 **Subscription Model**  
- 🎟️ Free version – General learning roadmaps.
- 🚀 Premium membership – AI-personalized paths, analytics, and more!  

---

## 🌍 Sustainability & Education 📚
EduRoad isn’t just about learning—it’s about **impact**. 🌱

🌎 Supports **Quality Education (SDG 4)** by making learning more **accessible & efficient**.  
🌱 Guides learners toward **sustainable practices** (eco-friendly choices, ethical consumption).  
📖 Helps teachers create **lesson plans & sustainability-focused content**.  
🎧 Includes **audio & visual learning options** for different learning styles.  

With EduRoad, knowledge isn't just power—it’s a **force for positive change**! 🔥

---

### 🔹 Fetching AI-Generated Information
```dart
class ApiService {
   static Logger logger = Logger();
   static Future<String> fetchInfo(String content) async {
       try {
           var response = await http.post(
               Uri.parse(BASE_URL),
               headers: {
                   'Content-Type': 'application/json',
                   'Authorization': 'Bearer $API_KEY'
               },
               body: jsonEncode({
                   "model": "gpt-4o",
                   "messages": [{"role": "user", "content": content}],
                   "temperature": 0.6
               }),
           );

           if (response.statusCode == 200) {
               var data = jsonDecode(response.body);
               return data['choices'][0]['message']['content'];
           } else {
               logger.e("API Error: ${response.statusCode} - ${response.body}");
               return "Error: ${response.statusCode}";
           }
       } catch (err) {
           logger.i("Error: $err");
           return "An error occurred while fetching data.";
       }
   }
}
```

### 🔹 Fetching YouTube Videos
```dart
static Future<List<String>> fetchYouTubeVideos(String query, String context) async {
   try {
       String refinedQuery = "$query $context";
       final response = await http.get(
           Uri.parse("$YOUTUBE_BASE?part=snippet&q=$refinedQuery&type=video&maxResults=6&videoDuration=medium&key=$YOUTUBE_KEY"),
       );

       if (response.statusCode == 200) {
           final data = jsonDecode(response.body);
           final List videos = data["items"];
           return videos.take(4)
               .map((video) => "https://www.youtube.com/watch?v=${video["id"]["videoId"]}")
               .where((url) => !url.contains("shorts"))
               .toList();
       } else {
           logger.e("API Error: ${response.statusCode} - ${response.body}");
           return [];
       }
   } catch (err) {
       logger.e("Error fetching YouTube videos: $err");
       return [];
   }
}
```

---

## 🚀 Join the EduRoad Movement!
We’re on a mission to **revolutionize learning**. If you believe in making education more accessible, structured, and effective, join us! 

👨‍💻 **Contribute** – Want to help us build? Fork the repo and submit a PR!  
📢 **Spread the Word** – Share EduRoad with your network!  
💬 **Feedback?** – Open an issue or reach out!  

🔗 **Website:** [Coming Soon]  
📧 **Contact:** support@eduroad.ai  
📜 **License:** MIT  

🚀 *Let’s guide the world’s learners together!*

