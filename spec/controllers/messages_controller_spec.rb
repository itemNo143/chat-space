require 'rails_helper'

describe MessagesController do
# letを利用してテスト中使用するインスタンスを定義
  let(:group) { create(:group) }
  let(:user) { create(:user) }

  describe '#index' do

    context 'log in' do
    # この中にログインしている場合のテストを記述
      before do # beforeブロックに共通の処理をまとめることで、コードの量が減り、読みやすいテストを書くことができる
        login user
        get :index, params: { group_id: group.id }
      end

      it 'assigns @message' do # assigns(:message)がMessageクラスのインスタンスかつ未保存かどうかをチェック
        expect(assigns(:message)).to be_a_new(Message)
      end

      it 'assigns @group' do # assigns(:group)とgroupが同一であることを確かめることでテスト
        expect(assigns(:group)).to eq group
      end

      it 'renders index' do # example内でリクエストが行われた時の遷移先のビューが、indexアクションのビューと同じかどうか確かめる
        expect(response).to render_template :index
      end
    end

    context 'not log in' do
    # この中にログインしていない場合のテストを記述
      before do # beforeブロックに共通の処理をまとめることで、コードの量が減り、読みやすいテストを書くことができる
        get :index, params: { group_id: group.id }
      end

      it 'redirects to new_user_session_path' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe '#create' do
    let(:params) { { group_id: group.id, user_id: user.id, message: attributes_for(:message) } }

    context 'log in' do
    # この中にログインしている場合のテストを記述
      before do
        login user
      end

      context 'can save' do
      # この中にメッセージの保存に成功した場合のテストを記述
        subject {
          post :create,
          params: params
        }

        it 'count up message' do
          expect{ subject }.to change(Message, :count).by(1)
        end

        it 'redirects to group_messages_path' do
          subject
          expect(response).to redirect_to(group_messages_path(group))
        end
      end

      context 'can not save' do
      # この中にメッセージの保存に失敗した場合のテストを記述
        let(:invalid_params) { { group_id: group.id, user_id: user.id, message: attributes_for(:message, content: nil, image: nil) } }

        subject {
          post :create,
          params: invalid_params
        }

        it 'does not count up' do
          expect{ subject }.not_to change(Message, :count)
        end

        it 'renders index' do
          subject
          expect(response).to render_template :index
        end
      end
    end

    context 'not log in' do
    # この中にログインしていない場合のテストを記述
      it 'redirects to new_user_session_path' do
        post :create, params: params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end