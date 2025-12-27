part of 'pages.dart';

class CreateEventView extends StatefulWidget {
  const CreateEventView({super.key});

  @override
  State<CreateEventView> createState() => _CreateEventViewState();
}

class _CreateEventViewState extends State<CreateEventView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserViewModel>().fetchUsers();
    });
  }

  int _currentStep = 0;
  bool _isUploading = false;

  // --- 1. Event Bio Data ---
  final titleController = TextEditingController();
  // REMOVED: final categoryController = TextEditingController(); 
  final descController = TextEditingController();
  final locationController = TextEditingController();
  final roomController = TextEditingController();
  final priceController = TextEditingController();
  final quotaController = TextEditingController();
  final kpController = TextEditingController();

  // CHANGE: Added specific category options and a variable to store selection
  final List<String> _categoryOptions = ["pengmas", "career center", "international"];
  String? _selectedCategory;

  XFile? _selectedImageFile;
  DateTime? startDate;
  DateTime? endDate;
  bool isMandatory = false;

  // --- 2. Quiz & Committee Data ---
  final List<Quiz> _tempQuizzes = [];
  final List<String> _tempCommittees = [];

  @override
  void dispose() {
    titleController.dispose();
    // categoryController.dispose(); // No longer needed
    descController.dispose();
    locationController.dispose();
    roomController.dispose();
    priceController.dispose();
    quotaController.dispose();
    kpController.dispose();
    super.dispose();
  }

  // ... [Keep _pickImage and _pickDate as they were] ...
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _selectedImageFile = pickedFile);
    }
  }

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isStart) startDate = picked; else endDate = picked;
      });
    }
  }

  Future<void> _submitEvent() async {
    final eventVM = context.read<EventViewModel>();
    // 1. Access the AuthViewModel
    final authVM = context.read<AuthViewModel>();
    final cloudinary = CloudinaryService();

    // 2. Security Check: Ensure user is actually logged in
    final String currentUserId = authVM.userId;
    if (currentUserId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: You are not logged in.")),
      );
      return;
    }

    if (titleController.text.isEmpty || startDate == null || endDate == null || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill Title, Category, and Dates")),
      );
      return;
    }
    if (_selectedImageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Select an image")));
      return;
    }

    setState(() => _isUploading = true);

    String imageUrl = "";
    try {
      imageUrl = await cloudinary.uploadImage(_selectedImageFile!);
    } catch (e) {
      setState(() => _isUploading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Upload Failed: $e")));
      return;
    }

    Map<String, Quiz> quizzesMap = {};
    for (int i = 0; i < _tempQuizzes.length; i++) {
      quizzesMap["quiz_$i"] = _tempQuizzes[i];
    }

    final newEvent = Event(
      id: "",
      title: titleController.text,
      category: _selectedCategory!, 
      // 3. USE THE REAL ID HERE
      creatorId: currentUserId, 
      description: descController.text,
      startDate: startDate.toString().split(' ')[0],
      endDate: endDate.toString().split(' ')[0],
      image: imageUrl,
      kp: kpController.text,
      location: locationController.text,
      mandatory: isMandatory,
      price: int.tryParse(priceController.text) ?? 0,
      quizzes: quizzesMap,
      quota: int.tryParse(quotaController.text) ?? 0,
      room: roomController.text,
      committees: _tempCommittees,
      participantsList: [],
    );

    final resultId = await eventVM.addEvent(newEvent);

    setState(() => _isUploading = false);

    if (!mounted) return;
    if (resultId != null) {
      // Optional: Refresh user data if you track "eventsCreatedCount" locally
      // await authVM.refreshUserData(); 
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(eventVM.errorMessage ?? "Error")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isUploading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Create New Event")),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 2) {
            setState(() => _currentStep += 1);
          } else {
            _submitEvent();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep -= 1);
          } else {
            Navigator.pop(context);
          }
        },
        steps: [
          Step(
            title: const Text("Bio"),
            content: _EventBioForm(
              titleController: titleController,
              // CHANGE: Pass selected value, options, and callback instead of controller
              selectedCategory: _selectedCategory,
              categoryOptions: _categoryOptions,
              onCategoryChanged: (val) => setState(() => _selectedCategory = val),
              
              descController: descController,
              locationController: locationController,
              roomController: roomController,
              priceController: priceController,
              quotaController: quotaController,
              kpController: kpController,
              startDate: startDate,
              endDate: endDate,
              isMandatory: isMandatory,
              selectedImage: _selectedImageFile,
              onPickImage: _pickImage,
              onDatePick: (isStart) => _pickDate(context, isStart),
              onMandatoryChanged: (val) => setState(() => isMandatory = val!),
            ),
            isActive: _currentStep >= 0,
          ),
          // ... [Keep Step 2 (Quizzes) and Step 3 (Committees) exactly as they were] ...
           Step(
            title: const Text("Quizzes"),
            content: _EventQuizForm(
              quizzes: _tempQuizzes,
              onAddQuiz: (quiz) => setState(() => _tempQuizzes.add(quiz)),
              onRemoveQuiz: (index) => setState(() => _tempQuizzes.removeAt(index)),
            ),
            isActive: _currentStep >= 1,
          ),
          Step(
            title: const Text("Committees"),
            content: _EventCommitteeForm(
              committees: _tempCommittees,
              onAddCommittee: (name) => setState(() => _tempCommittees.add(name)),
              onRemoveCommittee: (index) => setState(() => _tempCommittees.removeAt(index)),
            ),
            isActive: _currentStep >= 2,
          ),
        ],
      ),
    );
  }
}

// ==========================================
// VIEW 1: Adding Event Bio (UPDATED)
// ==========================================
class _EventBioForm extends StatelessWidget {
  final TextEditingController titleController;
  
  // CHANGE: New fields for Dropdown logic
  final String? selectedCategory;
  final List<String> categoryOptions;
  final ValueChanged<String?> onCategoryChanged;

  final TextEditingController descController;
  final TextEditingController locationController;
  final TextEditingController roomController;
  final TextEditingController priceController;
  final TextEditingController quotaController;
  final TextEditingController kpController;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isMandatory;
  final XFile? selectedImage;
  final VoidCallback onPickImage;
  final Function(bool isStart) onDatePick;
  final ValueChanged<bool?> onMandatoryChanged;

  const _EventBioForm({
    required this.titleController,
    // CHANGE: Updated constructor
    required this.selectedCategory,
    required this.categoryOptions,
    required this.onCategoryChanged,
    
    required this.descController,
    required this.locationController,
    required this.roomController,
    required this.priceController,
    required this.quotaController,
    required this.kpController,
    required this.startDate,
    required this.endDate,
    required this.isMandatory,
    required this.selectedImage,
    required this.onPickImage,
    required this.onDatePick,
    required this.onMandatoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // --- Image Picker UI (Unchanged) ---
        GestureDetector(
          onTap: onPickImage,
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: selectedImage == null
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                      SizedBox(height: 5),
                      Text("Tap to upload Event Banner", style: TextStyle(color: Colors.grey)),
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: kIsWeb
                        ? Image.network(selectedImage!.path, fit: BoxFit.cover, width: double.infinity)
                        : Image.file(File(selectedImage!.path), fit: BoxFit.cover, width: double.infinity),
                  ),
          ),
        ),
        const SizedBox(height: 10),

        // --- Form Fields ---
        TextField(
          controller: titleController,
          decoration: const InputDecoration(labelText: "Event Title"),
        ),
        
        // CHANGE: Replaced TextField with DropdownButtonFormField
        const SizedBox(height: 10), // Add a little spacing
        DropdownButtonFormField<String>(
          value: selectedCategory,
          decoration: const InputDecoration(
            labelText: "Category",
            border: OutlineInputBorder(), // Optional: adds a border to match textfields
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          ),
          items: categoryOptions.map((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category.toUpperCase()), // Captialized for better UI
            );
          }).toList(),
          onChanged: onCategoryChanged,
        ),
        const SizedBox(height: 10),

        TextField(
          controller: descController,
          decoration: const InputDecoration(labelText: "Description"),
          maxLines: 3,
        ),
        
        // ... [Rest of the fields (Date, Price, Quota, etc) remain unchanged] ...
        Row(
          children: [
            Expanded(
              child: TextButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: Text(startDate == null ? "Start Date" : "${startDate!.toLocal()}".split(' ')[0]),
                onPressed: () => onDatePick(true),
              ),
            ),
            Expanded(
              child: TextButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: Text(endDate == null ? "End Date" : "${endDate!.toLocal()}".split(' ')[0]),
                onPressed: () => onDatePick(false),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: quotaController,
                decoration: const InputDecoration(labelText: "Quota"),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        TextField(
          controller: kpController,
          decoration: const InputDecoration(labelText: "KP Points"),
        ),
        TextField(
          controller: locationController,
          decoration: const InputDecoration(labelText: "Location"),
        ),
        TextField(
          controller: roomController,
          decoration: const InputDecoration(labelText: "Room"),
        ),
        CheckboxListTile(
          title: const Text("Mandatory Event"),
          value: isMandatory,
          onChanged: onMandatoryChanged,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }
}


// ==========================================
// VIEW 2: Adding Quiz
// ==========================================
class _EventQuizForm extends StatelessWidget {
  final List<Quiz> quizzes;
  final ValueChanged<Quiz> onAddQuiz;
  final ValueChanged<int> onRemoveQuiz;

  const _EventQuizForm({
    required this.quizzes,
    required this.onAddQuiz,
    required this.onRemoveQuiz,
  });

  void _showAddQuizDialog(BuildContext context) {
    final questionCtrl = TextEditingController();
    final optACtrl = TextEditingController();
    final optBCtrl = TextEditingController();
    final optCCtrl = TextEditingController();
    final optDCtrl = TextEditingController();
    String correctAnswer = "A";

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Add Quiz Question"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: questionCtrl,
                decoration: const InputDecoration(labelText: "Question"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: optACtrl,
                decoration: const InputDecoration(labelText: "Option A"),
              ),
              TextField(
                controller: optBCtrl,
                decoration: const InputDecoration(labelText: "Option B"),
              ),
              TextField(
                controller: optCCtrl,
                decoration: const InputDecoration(labelText: "Option C"),
              ),
              TextField(
                controller: optDCtrl,
                decoration: const InputDecoration(labelText: "Option D"),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: correctAnswer,
                decoration: const InputDecoration(labelText: "Correct Answer"),
                items: ["A", "B", "C", "D"]
                    .map(
                      (e) =>
                          DropdownMenuItem(value: e, child: Text("Option $e")),
                    )
                    .toList(),
                onChanged: (val) => correctAnswer = val!,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (questionCtrl.text.isNotEmpty) {
                final newQuiz = Quiz(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  text: questionCtrl.text,
                  options: {
                    "A": optACtrl.text,
                    "B": optBCtrl.text,
                    "C": optCCtrl.text,
                    "D": optDCtrl.text,
                  },
                  correct_answer: correctAnswer,
                );
                onAddQuiz(newQuiz);
                Navigator.pop(ctx);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: () => _showAddQuizDialog(context),
          icon: const Icon(Icons.add),
          label: const Text("Add New Question"),
        ),
        const SizedBox(height: 10),
        quizzes.isEmpty
            ? const Text(
                "No quizzes added yet.",
                style: TextStyle(color: Colors.grey),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: quizzes.length,
                itemBuilder: (context, index) {
                  final quiz = quizzes[index];
                  return Card(
                    child: ListTile(
                      title: Text("Q: ${quiz.text}"),
                      subtitle: Text("Ans: ${quiz.correct_answer}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => onRemoveQuiz(index),
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }
}

// ==========================================
// VIEW 3: Adding Committees
// ==========================================
class _EventCommitteeForm extends StatefulWidget {
  final List<String> committees; // Stores User IDs
  final ValueChanged<String> onAddCommittee;
  final ValueChanged<int> onRemoveCommittee;

  const _EventCommitteeForm({
    required this.committees,
    required this.onAddCommittee,
    required this.onRemoveCommittee,
  });

  @override
  State<_EventCommitteeForm> createState() => _EventCommitteeFormState();
}

class _EventCommitteeFormState extends State<_EventCommitteeForm> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Access the UserViewModel
    final userVM = context.watch<UserViewModel>();

    return Column(
      children: [
        // --- Search Bar ---
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: "Search by Name or NIM",
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      context.read<UserViewModel>().searchUser("");
                    },
                  )
                : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onChanged: (val) => context.read<UserViewModel>().searchUser(val),
        ),
        const SizedBox(height: 10),

        // --- Selected Count ---
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Selected: ${widget.committees.length}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
        const Divider(),

        // --- User List ---
        userVM.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SizedBox(
                height:
                    300, // Fixed height for the list to scroll inside the Stepper
                child: ListView.builder(
                  itemCount: userVM.users.length,
                  itemBuilder: (context, index) {
                    final user = userVM.users[index];
                    final isSelected = widget.committees.contains(user.id);

                    return CheckboxListTile(
                      title: Text(user.fullName),
                      subtitle: Text(
                        "NIM: ${user.nim} • ${user.organizationTitle}",
                      ),
                      value: isSelected,
                      activeColor: Colors.deepPurple,
                      onChanged: (bool? value) {
                        if (value == true) {
                          // Add ID to parent list
                          widget.onAddCommittee(user.id);
                        } else {
                          // Remove ID. We need to find the index of this ID in the parent list
                          // because your parent removes by Index, not by ID.
                          final indexInList = widget.committees.indexOf(
                            user.id,
                          );
                          if (indexInList != -1) {
                            widget.onRemoveCommittee(indexInList);
                          }
                        }
                      },
                    );
                  },
                ),
              ),
      ],
    );
  }
}
