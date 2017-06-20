require 'rails_helper'
# Đây là một ví dụ minh họa về tét controller, về cơ bản việc test ở controller là kiểm tra:
# + các biến trong từng action có đưọc gán đúng như mong muốn không,
# + các action đó sẽ redirect hoặc là render đến file template nào, đúng mong đợi không.
RSpec.describe EkisController, type: :controller do
  # fixtures này có tác dụng lamf mới các bản ghi trong bảng ekis với dữ liệu lấy từ file ekis.yml  
  fixtures :ekis
  
  # Để test action Create ta cần các thuộc tính cho Eki mới, nên ta cần chuẩn bị các thứ sau:
  # ta thiết lập một hash chứa các thuộc tính hợp lệ:
  let(:valid_attributes) {  {駅コード: "12345", 駅名: "元町123", 駅名カナ: ""} }
  # và một hash chứa các thuộc tính không hợp lệ
  let(:invalid_attributes) { {駅コード: Eki.first.駅コード, 駅名: "元町123", 駅名カナ: ""} }

  # bởi vì trong controller có các code before_action( ví dụ như yêu cầu đăng nhập chẳng hạn)
  # nhưng ta ko care mấy việc đó khi test controller, nên ta gán thẳng một số giá trị cho 
  # cái phiên hiện tại, kiểu như là coi như có người đăng nhập xong rồi ý.
  let(:valid_session) { {current_user_id: User.first.id} }

  describe "GET #index" do
    it "assigns all ekis as @ekis" do      
      get :index, params: {},session: valid_session
      # điều này có nghĩa là : sau khi gọi action index, mong đợi cái biến @ekis sẽ dc
      # nhận giá trị bằng với Eki.all
      expect(assigns(:ekis)).to eq(Eki.all)
    end
  end

  describe "GET #show" do
    it "assigns the requested eki as @eki" do
      eki = Eki.last
      get :show, params: {:id => eki.to_param},session: valid_session
      expect(assigns(:eki)).to eq(eki)
    end
  end

  describe "GET #new" do
    it "assigns a new eki as @eki" do
      get :new, session: valid_session
      # sau khi gọi action new, mong muốn biến @eki sẽ là một biến kiểu Eki
      expect(assigns(:eki)).to be_a_new(Eki)
    end
  end

  describe "GET #edit" do
    it "assigns the requested eki as @eki" do
      eki = Eki.last
      get :edit, params: {:id => eki.to_param},session: valid_session
      expect(assigns(:eki)).to eq(eki)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Eki" do
        # đoạn dưới đây được hiểu là: mong đợi action create sẽ làm thay đổi Eki.count, 
        # by(1) đồng nghĩa với Eki.count mới sẽ hơn Eki.count cũ (trước khi gọi action) 1 đơn vị.
        expect {
          post :create,params: {:eki => valid_attributes},session: valid_session
        }.to change(Eki, :count).by(1)
      end

      it "assigns a newly created eki as @eki" do
        post :create,params: {:eki => valid_attributes},session: valid_session
        expect(assigns(:eki)).to be_a(Eki)
        expect(assigns(:eki)).to be_persisted# có nghĩa là mong chờ biến @eki đã đc lưu vào database
      end

      it "redirects to the created eki" do
        post :create,params: {:eki => valid_attributes},session: valid_session
        # sau khi create xong, thường ta sẽ redirect đến trang của cái bản ghi vừa tạo,
        # thế nên ta có code test như sau:
        expect(response).to redirect_to(Eki.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved eki as @eki" do
        post :create,params: {:eki => invalid_attributes},session: valid_session
        expect(assigns(:eki)).to be_a_new(Eki)
      end

      it "re-renders the 'new' template" do
        post :create,params: {:eki => invalid_attributes},session: valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) { {駅名: "hungnd", 駅名カナ: "1989"} }

      it "updates the requested eki" do
        eki = Eki.first
        put :update, params: {:id => eki.to_param, :eki => new_attributes},session: valid_session
        eki.reload
        #sau khi cập nhật eki, mong đợi các giá trị mới của eki như sau:
        expect(eki.駅名).to eq("hungnd")
        expect(eki.駅名カナ).to eq("1989")
      end      

      it "redirects to the eki" do
        eki = Eki.create! valid_attributes
        put :update, params: {:id => eki.to_param, :eki => valid_attributes},session: valid_session
        expect(response).to redirect_to(eki)
      end
    end

    context "with invalid params" do
      it "assigns the eki as @eki" do
        eki = Eki.first
        put :update,params: {:id => eki.to_param, :eki => invalid_attributes},session: valid_session
        expect(assigns(:eki)).to eq(eki)
      end

      it "re-renders the 'edit' template" do
        eki = Eki.first
        put :update,params: {:id => eki.to_param, :eki => invalid_attributes},session: valid_session
        expect(response).to redirect_to(eki)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested eki" do
      eki = Eki.first
      expect {
        delete :destroy, params: {:id => eki.to_param}, session: valid_session
      }.to change(Eki, :count).by(-1)
    end

    it "redirects to the ekis list" do
      eki = Eki.first
      delete :destroy,params: {:id => eki.to_param},session: valid_session
      expect(response).to redirect_to(ekis_url)
    end
  end

end
