import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/home_appbar.dart';
import '../providers/product_provider.dart';
import '../utilities/categoryutils.dart';
import '../models/product.dart';
import '../widgets/home/category_list.dart';
import '../widgets/home/product_grid.dart';
import 'upload.dart';
import 'cart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 현재 선택된 카테고리
  String selectedCategory = CategoryUtils.categories[0];
  // 필터링에 사용될 카테고리
  String? filterCategory;
  // 마지막 탭 시간을 저장하는 변수 (더블 탭 감지용)
  DateTime? lastTapTime;

  @override
  void initState() {
    super.initState();
    // 위젯이 처음 생성될 때 샘플 상품 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  // 초기 상품 데이터 로드 함수
  Future<void> _loadInitialData() async {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    await provider.loadSampleProducts();
  }

  // 카테고리 버튼 탭 처리 함수
  void handleCategoryTap(String category) {
    final now = DateTime.now();
    // 더블 탭 감지 (500ms 이내에 같은 카테고리를 두 번 탭)
    if (lastTapTime != null &&
        now.difference(lastTapTime!) < const Duration(milliseconds: 500) &&
        category == selectedCategory) {
      setState(() {
        filterCategory = null;
        selectedCategory = '';
        lastTapTime = null;
      });
    } else {
      setState(() {
        selectedCategory = category;
        filterCategory = category;
        lastTapTime = now;
      });
    }
  }

  // 선택된 카테고리에 따라 상품 목록 필터링
  List<Product> getFilteredProducts(List<Product> products) {
    if (filterCategory == null) {
      return products;
    }
    return products
        .where((product) => product.category == filterCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 상단 앱바 (장바구니 아이콘 포함)
      appBar: HomeAppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Consumer<ProductProvider>(
          builder: (context, productProvider, _) {
            // 필터링된 상품 목록 가져오기
            final filteredProducts =
                getFilteredProducts(productProvider.products);

            return Column(
              children: [
                CategoryList(
                  selectedCategory: selectedCategory,
                  onCategoryTap: handleCategoryTap,
                ),
                Expanded(
                  child: ProductGrid(
                    products: filteredProducts,
                    onDeleteProduct: productProvider.removeProduct,
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UploadPage()),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
