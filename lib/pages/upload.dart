// 상품 등록 페이지
// 새로운 상품을 등록할 수 있는 화면
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../utilities/categoryutils.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../widgets/appbar.dart';
import '../utilities/custom_text_field.dart';
import '../widgets/upload/image_picker_widget.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  // 폼 검증을 위한 키
  final _formKey = GlobalKey<FormState>();
  // 상품명 입력 컨트롤러
  final _nameController = TextEditingController();
  // 가격 입력 컨트롤러
  final _priceController = TextEditingController();
  // 상품 설명 입력 컨트롤러
  final _descriptionController = TextEditingController();
  // 선택된 카테고리
  String _selectedCategory = CategoryUtils.categories[0];
  // 선택된 이미지 파일
  File? _image;

  // 이미지 선택 함수
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // 폼 제출 함수
  void _submitForm() {
    if (_formKey.currentState!.validate() && _image != null) {
      final provider = Provider.of<ProductProvider>(context, listen: false);

      // 이미지를 assets 폴더에 복사하는 로직이 필요합니다.
      // 임시로 기본 이미지 경로를 사용
      const defaultImagePath = 'assets/logo.png';

      // 새 상품 객체 생성
      final product = Product(
        id: DateTime.now().toString(),
        name: _nameController.text,
        price: double.parse(_priceController.text),
        description: _descriptionController.text,
        category: _selectedCategory,
        image: defaultImagePath, // 실제로는 복사된 이미지 경로를 사용해야 함
      );

      // 상품 추가
      provider.addProduct(product);
      Navigator.pop(context);
    } else if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미지를 선택해주세요')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PageAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImagePickerWidget(
                  image: _image,
                  onTap: _pickImage,
                ),
                const SizedBox(height: 16),
                // 상품명 입력 필드
                CustomTextField(
                  label: '상품명',
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) return '상품명을 입력해주세요';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // 가격 입력 필드
                CustomTextField(
                  label: '가격',
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  suffixText: '원',
                  validator: (value) {
                    if (value == null || value.isEmpty) return '가격을 입력해주세요';
                    if (double.tryParse(value) == null) return '올바른 가격을 입력해주세요';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // 카테고리 선택 드롭다운
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: '카테고리',
                    border: OutlineInputBorder(),
                  ),
                  items: CategoryUtils.categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                // 상품 설명 입력 필드
                CustomTextField(
                  label: '상품 설명',
                  controller: _descriptionController,
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) return '상품 설명을 입력해주세요';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                // 상품 등록 버튼
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFFFEE7C5),
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('상품 등록'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // 컨트롤러 해제
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
