require 'csv'
require "test_helper"
require 'set'

class ProductTest < ActiveSupport::TestCase
end

class ProductTestBasic < ProductTest
  def setup
    @ulf = UploadedFile.create()
    @mdp0 = MassDataPoint.new(unit: 'kilogram', mass: 1, uploaded_file: @ulf, product_id: "product0")
    @mdp1 = MassDataPoint.new(unit: 'gram', mass: 10, uploaded_file: @ulf, product_id: "product0")
    @mdp2 = MassDataPoint.new(unit: 'pounds', mass: 1, uploaded_file: @ulf, product_id: "product1")
    
    @product0 = Product.new(
      categoryId: "TEST",
      productId: "abc123",
      mass_data_points: [
      @mdp0,
      @mdp1,
    ])

    @product1 = Product.new(
      categoryId: "TEST1",
      productId: "xyz987",
      mass_data_points: [
      @mdp2
    ])

    @ulf.save()
    @mdp0.save()
    @mdp1.save()
    @mdp2.save()
    @product0.save()
    @product1.save()

  end
  
  def teardown
    @ulf = nil
    @mdp0 = nil
    @mdp1 = nil
    @mdp2 = nil
    @product0 = nil
    @product1 = nil
  end

  test 'valid product' do
    assert @product0.valid?
  end

  test 'Product association' do
    assert_equal @product0.mass_data_points, [@mdp0, @mdp1]
    assert_equal @product1.mass_data_points, [@mdp2]
  end

  test 'UploadedFile association' do
    assert_equal @product0.uploaded_files, [@ulf]
  end
end

class ProductTestFile < ProductTest
  def setup
    @ulf = UploadedFile.new()
    @ulf.source_csv_file.attach(io: File.open('./test/fixtures/files/scale_1.csv'), filename: 'scale1.csv')
    @ulf.save!
    @ulf.ingest(CSV.read(ActiveStorage::Blob.service.path_for(@ulf.source_csv_file.key), headers: true))
  end
  
  def teardown
    @ulf = nil
  end

  test 'valid product' do
    assert @ulf.valid?
  end

   test 'the App payload' do
    appPayload = Product.app();

    # A list of all of the products grouped by category.
    assert_equal appPayload.collect {|key,value| key }, (['DAY', 'ONE'])

    assert_equal appPayload['DAY'][:productsInCategory].reduce([]) { |mm, lm|
      mm.push(lm["productId"])
    }.to_set, [
      '1A406020000607D000003322',
      '11A406020000607D000003347',
      '11A406020000607D000003339',
      '11A406020000007D000003355'
    ].to_set

    assert_equal appPayload['ONE'][:productsInCategory].reduce([]) { |mm, lm|
      mm.push(lm["productId"])
    }.to_set, [
      '11A406020000507D000003335',
      '11A4FF0200000022000002228'
    ].to_set

    # Total/sum weight of the products in each category in kilograms.
    assert_equal appPayload['ONE'][:total_converted_kilograms_of_products_incategory], 0.96
    assert_equal appPayload['DAY'][:total_converted_kilograms_of_products_incategory], 1.161

    # The date that the weighing process started for this import.
    assert_equal appPayload['ONE'][:productsInCategory].find{ | lm | 
        lm["productId"] == "11A406020000507D000003335"
    }[:earliest], ActiveSupport::TimeZone['UTC'].parse("2021-03-01 01:30:32.977497+00:00")

  end

end

class ProductTestFile2 < ProductTest
  def setup
    @ulf = UploadedFile.new()
    @ulf.source_csv_file.attach(io: File.open('./test/fixtures/files/scale_2.csv'), filename: 'scale2.csv')
    @ulf.save!
    @ulf.ingest(CSV.read(ActiveStorage::Blob.service.path_for(@ulf.source_csv_file.key), headers: true))
  end
  
  def teardown
    @ulf = nil
  end

  test 'valid product' do
    assert @ulf.valid?
  end

   test 'the App payload' do
    appPayload = Product.app();

    # A list of all of the products grouped by category.
    assert_equal appPayload.collect {|key,value| key }, (["GRP", 'DAY', 'ONE'])

    assert_equal appPayload['GRP'][:productsInCategory].reduce([]) { |mm, lm|
      mm.push(lm["productId"])
    }.to_set, [
      '1B406020000607D000003422',
      '18C406020000608E000003339'
    ].to_set

    assert_equal appPayload['DAY'][:productsInCategory].reduce([]) { |mm, lm|
      mm.push(lm["productId"])
    }.to_set, [
      '16A406020000707D000004447',
      '11B406020000007D000005655'
    ].to_set

    assert_equal appPayload['ONE'][:productsInCategory].reduce([]) { |mm, lm|
      mm.push(lm["productId"])
    }.to_set, [
      '11A406020000607D000003339',
      '11A4AF0200000022000006728'
    ].to_set

    # Total/sum weight of the products in each category in kilograms.
    assert_equal appPayload['GRP'][:total_converted_kilograms_of_products_incategory], 0.721
    assert_equal appPayload['DAY'][:total_converted_kilograms_of_products_incategory], 1.270
    assert_equal appPayload['ONE'][:total_converted_kilograms_of_products_incategory], 1.56

    # The date that the weighing process started for this import.
    assert_equal appPayload['GRP'][:productsInCategory].find{ | lm | 
        lm["productId"] == "18C406020000608E000003339"
    }[:earliest], ActiveSupport::TimeZone['UTC'].parse("2021-03-02 01:31:33.819767+00:00")

  end

end

class ProductTestFile3 < ProductTest
  def setup
    
    @ulf1 = UploadedFile.new()
    @ulf1.source_csv_file.attach(io: File.open('./test/fixtures/files/scale_1.csv'), filename: 'scale1.csv')
    @ulf1.save!
    @ulf1.ingest(CSV.read(ActiveStorage::Blob.service.path_for(@ulf1.source_csv_file.key), headers: true))
    
    @ulf2 = UploadedFile.new()
    @ulf2.source_csv_file.attach(io: File.open('./test/fixtures/files/scale_2.csv'), filename: 'scale2.csv')
    @ulf2.save!
    @ulf2.ingest(CSV.read(ActiveStorage::Blob.service.path_for(@ulf2.source_csv_file.key), headers: true))
  end
  
  def teardown
    @ulf1 = nil
    @ulf2 = nil
  end

  test 'valid product' do
    assert @ulf1.valid?
    assert @ulf2.valid?
  end

   test 'the App payload' do
    appPayload = Product.app();

    # A list of all of the products grouped by category.
    assert_equal appPayload.collect {|key,value| key }.to_set, (["GRP", 'DAY', 'ONE']).to_set

    assert_equal appPayload['GRP'][:productsInCategory].reduce([]) { |mm, lm|
      mm.push(lm["productId"])
    }.to_set, [
      '1B406020000607D000003422',
      '18C406020000608E000003339'
    ].to_set

    assert_equal appPayload['DAY'][:productsInCategory].reduce([]) { |mm, lm|
      mm.push(lm["productId"])
    }.to_set, [
      '16A406020000707D000004447',
      '11B406020000007D000005655',
      '1A406020000607D000003322',
      '11A406020000607D000003347',
      '11A406020000607D000003339',
      '11A406020000007D000003355',
    ].to_set

    assert_equal appPayload['ONE'][:productsInCategory].reduce([]) { |mm, lm|
      mm.push(lm["productId"])
    }.to_set, [
      '11A406020000607D000003339',
      '11A4AF0200000022000006728',
      '11A406020000507D000003335',
      '11A4FF0200000022000002228',
    ].to_set

    # # Total/sum weight of the products in each category in kilograms.
    assert_equal appPayload['GRP'][:total_converted_kilograms_of_products_incategory], 0.721
    assert_equal appPayload['DAY'][:total_converted_kilograms_of_products_incategory], 1.270 + 1.161
    assert_equal appPayload['ONE'][:total_converted_kilograms_of_products_incategory], 1.56 + 0.96

    # # The date that the weighing process started for this import.
    # assert_equal appPayload['GRP'][:productsInCategory].find{ | lm | 
    #     lm["productId"] == "18C406020000608E000003339"
    # }[:earliest], ActiveSupport::TimeZone['UTC'].parse("2021-03-02 01:31:33.819767+00:00")

  end

end

class ProductTestFile4 < ProductTest
  def setup
    @ulf = UploadedFile.new()
    @ulf.source_csv_file.attach(io: File.open('./test/fixtures/files/scale_3.csv'), filename: 'scale3.csv')
    @ulf.save!
    @ulf.ingest(CSV.read(ActiveStorage::Blob.service.path_for(@ulf.source_csv_file.key), headers: true))
  end
  
  def teardown
    @ulf = nil
  end

  test 'valid product' do
    assert @ulf.valid?
  end

   test 'the App payload' do
    appPayload = Product.app();

    # A list of all of the products grouped by category.
    assert_equal appPayload.collect {|key,value| key }.to_set, ["RED", "GRN", "YLW", "BLU"].to_set

    assert_equal appPayload['RED'][:productsInCategory].reduce([]) { |mm, lm|
      mm.push(lm["productId"])
    }.to_set, [
      '1B406020000607D000003422',
      '11B406020000007D000005655'
    ].to_set

    assert_equal appPayload['GRN'][:productsInCategory].reduce([]) { |mm, lm|
      mm.push(lm["productId"])
    }.to_set, [
      '16A406020000707D000004447',
      '11A4AF0200000022000006728'
    ].to_set


    assert_equal appPayload['YLW'][:productsInCategory].reduce([]) { |mm, lm|
      mm.push(lm["productId"])
    }.to_set, [
      '18C406020000608E000003339'
    ].to_set

    assert_equal appPayload['BLU'][:productsInCategory].reduce([]) { |mm, lm|
      mm.push(lm["productId"])
    }.to_set, [
      '11A406020000607D000003339'
    ].to_set

    # # Total/sum weight of the products in each category in kilograms.
    assert_in_epsilon appPayload['RED'][:total_converted_kilograms_of_products_incategory], 1.40410703
    assert_in_epsilon appPayload['GRN'][:total_converted_kilograms_of_products_incategory], 1.597
    assert_in_epsilon appPayload['YLW'][:total_converted_kilograms_of_products_incategory], 0.3764817
    assert_in_epsilon appPayload['BLU'][:total_converted_kilograms_of_products_incategory], 0.78
    

    # # The date that the weighing process started for this import.
    # assert_equal appPayload['GRP'][:productsInCategory].find{ | lm | 
    #     lm["productId"] == "18C406020000608E000003339"
    # }[:earliest], ActiveSupport::TimeZone['UTC'].parse("2021-03-02 01:31:33.819767+00:00")

  end

end

class ProductTestFile5 < ProductTest
  def setup
    
    @ulf1 = UploadedFile.new()
    @ulf1.source_csv_file.attach(io: File.open('./test/fixtures/files/scale_1.csv'), filename: 'scale1.csv')
    @ulf1.save!
    @ulf1.ingest(CSV.read(ActiveStorage::Blob.service.path_for(@ulf1.source_csv_file.key), headers: true))
    
    @ulf2 = UploadedFile.new()
    @ulf2.source_csv_file.attach(io: File.open('./test/fixtures/files/scale_2.csv'), filename: 'scale2.csv')
    @ulf2.save!
    @ulf2.ingest(CSV.read(ActiveStorage::Blob.service.path_for(@ulf2.source_csv_file.key), headers: true))

    @ulf3 = UploadedFile.new()
    @ulf3.source_csv_file.attach(io: File.open('./test/fixtures/files/scale_3.csv'), filename: 'scale3.csv')
    @ulf3.save!
    @ulf3.ingest(CSV.read(ActiveStorage::Blob.service.path_for(@ulf3.source_csv_file.key), headers: true))
  end
  
  def teardown
    @ulf1 = nil
    @ulf2 = nil
    @ulf3 = nil
  end

  test 'valid product' do
    assert @ulf1.valid?
    assert @ulf2.valid?
    assert @ulf3.valid? 
  end

   test 'the App payload' do
    appPayload = Product.app();

    # A list of all of the products grouped by category.
    assert_equal appPayload.collect {|key,value| key }.to_set, (["DAY", "ONE", "GRP", "RED", "GRN", "YLW", "BLU"]).to_set

    assert_equal appPayload['GRP'][:productsInCategory].reduce([]) { |mm, lm|
      mm.push(lm["productId"])
    }.to_set, [
      '1B406020000607D000003422',
      '18C406020000608E000003339'
    ].to_set

    assert_equal appPayload['DAY'][:productsInCategory].reduce([]) { |mm, lm|
      mm.push(lm["productId"])
    }.to_set, [
      '16A406020000707D000004447',
      '11B406020000007D000005655',
      '1A406020000607D000003322',
      '11A406020000607D000003347',
      '11A406020000607D000003339',
      '11A406020000007D000003355',
    ].to_set

    assert_equal appPayload['ONE'][:productsInCategory].reduce([]) { |mm, lm|
      mm.push(lm["productId"])
    }.to_set, [
      '11A406020000607D000003339',
      '11A4AF0200000022000006728',
      '11A406020000507D000003335',
      '11A4FF0200000022000002228',
    ].to_set

    # Total/sum weight of the products in each category in kilograms.
    assert_in_epsilon appPayload['GRP'][:total_converted_kilograms_of_products_incategory], 0.721
    assert_in_epsilon appPayload['DAY'][:total_converted_kilograms_of_products_incategory], 1.270 + 1.161
    assert_in_epsilon appPayload['ONE'][:total_converted_kilograms_of_products_incategory], 1.56 + 0.96
    assert_in_epsilon appPayload['RED'][:total_converted_kilograms_of_products_incategory], 1.40410703
    assert_in_epsilon appPayload['GRN'][:total_converted_kilograms_of_products_incategory], 1.597
    assert_in_epsilon appPayload['YLW'][:total_converted_kilograms_of_products_incategory], 0.3764817
    assert_in_epsilon appPayload['BLU'][:total_converted_kilograms_of_products_incategory], 0.78

    # The date that the weighing process started for this import.
    assert_equal appPayload['GRP'][:productsInCategory].find{ | lm | 
        lm["productId"] == "18C406020000608E000003339"
    }[:earliest], ActiveSupport::TimeZone['UTC'].parse("2021-03-02 01:31:33.819767+00:00")

    assert_equal appPayload['DAY'][:productsInCategory].find{ | lm | 
        lm["productId"] == "1A406020000607D000003322"
    }[:earliest], ActiveSupport::TimeZone['UTC'].parse("2021-03-01 01:30:32.977497+00:00")

  end

end