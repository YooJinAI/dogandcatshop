import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/category.dart';
import '../utilities/categoryutils.dart';
import '../widgets/home_appbar.dart';
import '../providers/product_provider.dart';
import '../models/product.dart';
import 'upload.dart';
import 'productdetail.dart';
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
                // 카테고리 선택 영역
                Container(
                  height: 120,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: CategoryUtils.categories.map((category) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: CategoryButton(
                            title: category,
                            isSelected: selectedCategory == category,
                            onTap: () => handleCategoryTap(category),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                // 상품 목록 그리드
                Expanded(
                  child: filteredProducts.isEmpty
                      ? const Center(
                          child: Text('등록된 상품이 없습니다.'),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.65,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                          ),
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];
                            return Card(
                              elevation: 2,
                              child: InkWell(
                                onTap: () {
                                  // 상품 상세 페이지로 이동
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetailPage(
                                        id: product.id,
                                      ),
                                    ),
                                  );
                                },
                                child: Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // 상품 이미지
                                        Expanded(
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  const BorderRadius.vertical(
                                                top: Radius.circular(4),
                                              ),
                                            ),
                                            child: Image.asset(
                                              product.image,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        // 상품 정보 (이름, 가격, 카테고리)
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  product.name,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      '${product.price.toStringAsFixed(0)}원',
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.green,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      product.category,
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // 상품 삭제 버튼
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: GestureDetector(
                                        onTap: () {
                                          // 삭제 확인 다이얼로그 표시
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('상품 삭제'),
                                              content:
                                                  const Text('이 상품을 삭제하시겠습니까?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('취소'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    productProvider
                                                        .removeProduct(
                                                            product.id);
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('삭제'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
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
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
