
# AI & Machine learning

- [AI \& Machine learning](#ai--machine-learning)
  - [Amazon Rekognition](#amazon-rekognition)
  - [Amazon Transcribe](#amazon-transcribe)
  - [Amazon Polly](#amazon-polly)
  - [Amazon Translate](#amazon-translate)
  - [Amazon Lex \& Amazon Connect](#amazon-lex--amazon-connect)
  - [Amazon Comprehend](#amazon-comprehend)
  - [Amazon Comprehend Medical](#amazon-comprehend-medical)
  - [Amazon SageMaker](#amazon-sagemaker)
  - [Amazon Kendra](#amazon-kendra)
  - [Amazon Personalize](#amazon-personalize)
  - [Amazon Textract — SAA Cheat Sheet](#amazon-textract--saa-cheat-sheet)
  - [AWS Machine Learning Services](#aws-machine-learning-services)

## Amazon Rekognition

### What It Is 🤖
- Fully managed ML service for **image & video analysis**
- No ML expertise required

### Core Capabilities
- **Image/Video Labeling**: objects, scenes, activities
- **Face Detection & Analysis**: age range, gender, emotions
- **Face Search & Verification**: compare faces, user identity
- **Celebrity Recognition**
- **Text Detection**: OCR in images/videos
- **Pathing**: track movement in videos (sports, analytics)

### Key Use Cases
- Security & user verification
- Media analysis & sports analytics
- Social networks & content platforms
- Advertising & e-commerce moderation

### Content Moderation ⭐ (Exam Favorite)
- Detect **inappropriate/offensive content**
  - Violence, nudity, racism, pornography, etc.
- Works for **images & videos**
- Configure **Minimum Confidence Threshold**
  - Lower threshold → more matches
- Helps with **safe user experience & compliance**

### Human Review (Optional)
- **Amazon A2I (Augmented AI)** 👤
- Manual review of flagged content
- Used after Rekognition automated detection

### SAA Exam Tips 🎯
- Rekognition = **images + videos only**
- Content moderation → Rekognition + **confidence threshold**
- Manual review → **Amazon A2I**
- Serverless, scalable, managed ML service

---
## Amazon Transcribe

### What It Is 🎙️
- Fully managed **speech-to-text** service
- Converts **audio → text** using **ASR (Automatic Speech Recognition)**

### Key Features
- **High accuracy & near real-time transcription**
- **PII Redaction** 🔒
  - Automatically removes sensitive data
  - Name, age, phone number, SSN, etc.
- **Automatic Language Identification**
  - Detects multiple languages in same audio
- **Streaming & batch transcription**

### Common Use Cases
- **Customer service call transcription**
- **Closed captioning & subtitles**
- **Searchable media archives (metadata generation)**

### SAA Exam Tips 🎯
- Transcribe = **audio only** (not images/video)
- PII removal = **built-in redaction feature**
- Multilingual audio → **automatic language detection**
- Serverless, scalable, no ML setup required

---
## Amazon Polly

### What It Is 🔊
- Fully managed **text-to-speech** service
- Uses **deep learning** to generate lifelike speech

### Core Features
- **Text → Audio** output
- Multiple **voices & languages**
- **Neural voices** = most natural speech

### Pronunciation Control
- **Pronunciation Lexicons** 📘
  - Custom word pronunciation
  - Acronyms (e.g., AWS → Amazon Web Services)
  - Stylized words (e.g., names, brands)
- Uploaded & used during `SynthesizeSpeech`

### Speech Customization
- **SSML (Speech Synthesis Markup Language)** 📝
  - Control *how* speech sounds
  - Emphasis, pauses (breaks), whispering
  - Phonetic pronunciation
  - Speaking styles (e.g., Newscaster)

### Typical Use Cases
- Voice assistants & chatbots
- Accessibility (screen readers)
- Audio content generation
- Interactive applications

### SAA Exam Tips 🎯
- Polly = **text → speech** (opposite of Transcribe)
- **Lexicons** = pronunciation of words/acronyms
- **SSML** = speech style & delivery control
- Serverless, scalable, no ML setup required

---
## Amazon Translate

### What It Is 🌍
- Fully managed **neural machine translation** service
- Translates **text between languages** accurately & at scale

### Core Capabilities
- **Real-time & batch translation**
- Supports many **source & target languages**
- Handles **large volumes of text efficiently**

### Common Use Cases
- Website & application **localization**
- Multilingual user experiences
- Translating documents, messages, content

### SAA Exam Tips 🎯
- Translate = **text-to-text language translation**
- Used for **internationalization (i18n) & localization**
- Serverless, scalable, no ML expertise required

---
## Amazon Lex & Amazon Connect

### Amazon Lex 🤖
- Same tech as **Amazon Alexa**
- Build **chatbots & voice bots**
- **ASR**: speech → text
- **NLU**: understands user intent
- Integrates with **AWS Lambda** for backend logic

### Amazon Connect ☎️
- Fully managed **cloud contact center**
- Create **contact flows** visually
- Receive & manage phone calls
- Integrates with **CRMs & AWS services**
- **No upfront cost**, pay-as-you-go
- ~**80% cheaper** than traditional call centers

### Typical Architecture
- Phone call → **Amazon Connect**
- Speech streamed to **Amazon Lex**
- Lex detects **intent**
- Triggers **AWS Lambda**
- Lambda updates **CRM / backend systems**

### SAA Exam Tips 🎯
- **Lex = ASR + NLU (chatbots, voice bots)**
- **Connect = contact center service**
- Lex commonly paired with **Lambda**
- Used together for **intelligent call centers**
- Fully managed & serverless

---
## Amazon Comprehend

### What It Is 🧠
- Fully managed, serverless **NLP (Natural Language Processing)** service
- Uses ML to **analyze & understand text**

### Core Capabilities
- **Language detection**
- **Entity extraction**: people, places, brands, events
- **Key phrase extraction**
- **Sentiment analysis** 😊😐😠
- **Tokenization & parts of speech**
- **Topic modeling** (auto-group documents)

### Input Types
- **Text & unstructured data**
- (Exam focus: text analysis)

### Common Use Cases
- Analyze **customer feedback & emails**
- Understand **positive vs negative sentiment**
- Automatically **group articles by topic**
- Extract insights from large text datasets

### SAA Exam Tips 🎯
- NLP on exam → **Amazon Comprehend**
- Converts **unstructured text → structured insights**
- Serverless, scalable, no ML setup required

---
## Amazon Comprehend Medical

### What It Is 🏥
- Fully managed, serverless **medical NLP** service
- Extracts insights from **unstructured clinical text**

### Core Capabilities
- **Medical entity extraction**
  - Conditions, medications, procedures, dosages
- **PHI detection** 🔐
  - Protected Health Information via **DetectPHI API**
- Structures messy clinical notes into **organized data**

### Typical Architecture
- Clinical text stored in **Amazon S3**
- Invoke **Comprehend Medical API**
- Real-time analysis via **Kinesis Data Firehose**
- Audio notes → **Amazon Transcribe** → text → Comprehend Medical

### Common Use Cases
- Doctor notes & discharge summaries
- Medical records analysis
- Compliance & PHI identification
- Structuring healthcare data for analytics

### SAA Exam Tips 🎯
- Healthcare NLP → **Comprehend Medical** (not regular Comprehend)
- PHI detection = **DetectPHI API**
- Often combined with **S3, Transcribe, Kinesis**
- Serverless, scalable, ML-powered

---
## Amazon SageMaker

### What It Is 🧪
- Fully managed service to **build, train, tune & deploy ML models**
- Used by **developers & data scientists**
- More flexible than prebuilt AI services

### When to Use
- Need **custom ML models**
- Prebuilt services (Translate, Transcribe, Comprehend, Polly) not enough

### ML Lifecycle (Handled by SageMaker)
- **Data collection & labeling**
- **Model building**
- **Training & tuning**
- **Deployment & inference**
- **End-to-end ML workflow in one service**

### Key Benefits
- No manual server provisioning
- Scales compute automatically
- Simplifies complex ML pipelines

### Typical Architecture
- Data in **Amazon S3**
- Use **SageMaker** for:
  - Labeling
  - Training
  - Hosting models
- New data → **model inference (predictions)**

### Example Use Cases
- Prediction systems (scores, fraud, demand)
- Custom ML for business logic
- Advanced analytics beyond built-in AI services

### SAA Exam Tips 🎯
- Custom ML → **Amazon SageMaker**
- Prebuilt AI (speech, text, vision) ≠ SageMaker
- Covers **entire ML lifecycle**
- Fully managed, scalable, serverless-like experience

---
## Amazon Kendra

### What It Is 🔍
- Fully managed **ML-powered document search** service
- Finds **answers inside documents** (not just keywords)

### Supported Content
- Text, **PDF, HTML**
- **Word, PowerPoint**
- FAQs, knowledge bases, docs

### Core Capabilities
- **Natural language search** (Google-like)
- **Answer extraction** from indexed content
- Builds a **knowledge index** using ML
- **Incremental learning** 📈
  - Improves results from user feedback
- **Relevance tuning**
  - Boost by freshness, importance, metadata filters

### Common Use Cases
- Enterprise search
- Internal knowledge bases
- IT helpdesk & FAQs
- Document-heavy applications

### SAA Exam Tips 🎯
- Document search with ML → **Amazon Kendra**
- Answers *from documents*, not full-text search
- Fully managed, no ML setup required
- Think **enterprise search** on the exam

---
## Amazon Personalize

### What It Is 🎯
- Fully managed **ML-based recommendation** service
- Delivers **real-time personalized recommendations**
- Same tech used by **Amazon.com**

### Recommendation Types
- **Product recommendations**
- **Re-ranking** results
- **Personalized marketing** (email, SMS)
- User-specific content suggestions

### Data & Integration
- Input data from **Amazon S3**
  - User interactions, events, history
- **Real-time updates** via Personalize APIs
- Outputs via **custom recommendation APIs**
  - Web, mobile apps, marketing systems

### Key Benefits
- No custom ML model building
- **Days, not months** to deploy
- Fully managed & scalable

### Common Use Cases
- E-commerce product suggestions
- Media & entertainment content recommendations
- Personalized user experiences

### SAA Exam Tips 🎯
- Personalized recommendations → **Amazon Personalize**
- Real-time, user-specific suggestions
- Prebuilt ML (not SageMaker)
- Think **retail, media, personalization**

---
## Amazon Textract — SAA Cheat Sheet

### What It Is 📄
- Fully managed **AI-powered text extraction** service
- Extracts **printed text, handwriting & data** from documents

### Core Capabilities
- **OCR** on PDFs & images
- Extracts **forms & tables** automatically
- Returns **structured data** (key-value pairs)

### Supported Inputs
- Scanned documents
- PDFs, images
- IDs, forms, reports

### Common Use Cases
- **Invoices & financial reports**
- **Medical records & insurance claims**
- **Tax forms, IDs, passports**
- Automating document processing

### SAA Exam Tips 🎯
- Text extraction from documents → **Amazon Textract**
- Handles **forms & tables** (key differentiator)
- Uses ML, fully managed & serverless
- Often paired with **S3** for document storage

---
## AWS Machine Learning Services

### Computer Vision 👁️
- **Amazon Rekognition**  
  - Image & video analysis  
  - Face detection, labeling, celebrity recognition

### Speech & Language 🎙️🗣️
- **Amazon Transcribe** → Audio ➝ Text (subtitles)
- **Amazon Polly** → Text ➝ Speech
- **Amazon Translate** → Language translation (text ↔ text)

### Conversational AI ☎️
- **Amazon Lex** → Chatbots & voice bots (ASR + NLU)
- **Amazon Connect** → Cloud contact center (often with Lex)

### Natural Language Processing 🧠
- **Amazon Comprehend** → NLP (sentiment, entities, key phrases)
- **Amazon Comprehend Medical** → Medical NLP + PHI detection

### Search & Recommendations 🔍🎯
- **Amazon Kendra** → ML-powered document search
- **Amazon Personalize** → Real-time personalized recommendations

### Document Processing 📄
- **Amazon Textract** → OCR, forms & tables extraction

### Custom Machine Learning 🧪
- **Amazon SageMaker** → Build, train, tune & deploy ML models

### SAA Exam Tips 🎯
- Know **service → use case mapping**
- Prebuilt AI ≠ **SageMaker**
- Most services are **serverless & fully managed**
- Recognizing the right service = easy exam points
