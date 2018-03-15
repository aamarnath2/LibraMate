package CSCI201Assignment3;

import java.util.ArrayList;

public class Database {
	ArrayList<User> users;
	public Database(ArrayList<User> users) {
		this.users = users;
	}
	
	public ArrayList<User> getUsers() {
		return users;
	}
}

class User {
		private String username;
		private String password;
		private String imageURL;
		private ArrayList<String> followers; //Change to user ArrayLists
		private ArrayList<String> following; //Change to user ArrayLists
		private Library library;
		
		public User(String u, String p, String i) {
			this.username = u;
			this.password = p;
			this.imageURL = i;
			this.followers = new ArrayList<String>();
			this.following = new ArrayList<String>();
			this.library = new Library();
		}
		
		public String getUsername() {
			return username;
		}
		
		public String getPassword() {
			return username;
		}
		
		public String getimageURL() {
			return username;
		}
		
		public ArrayList<String> getfollowers() {
			return followers;
		}
		
		public ArrayList<String> getfollowing() {
			return following;
		}
		
		public Library getLibrary() {
			return this.library;
		}
		
		public void setUsername(String un) {
			this.username = un;
		}
		
		public void setPassword(String pw) {
			this.password = pw;
		}
		
		public void setImage(String image) {
			this.imageURL = image;
		}
		
		public void addFollowers(String person) {
			this.followers.add(person);
		}
		
		public void addFollowing(String person) {
			this.following.add(person);
		}
		
		public void removeFollowing(String person) {
			for(int i = 0; i < this.following.size(); i++) {
				if(person == following.get(i))
					following.remove(i);
			}
		}
		
		public void removeFollowers(String person) {
			for(int i = 0; i < this.followers.size(); i++) {
				if(person == followers.get(i))
					followers.remove(i);
			}
		}
}
		
class Library {
	private ArrayList<String> favorite;
	private ArrayList<String> read;
	public Library() {
		favorite = new ArrayList<String>();
		read = new ArrayList<String>();
	}
 	public Library(ArrayList<String> r, ArrayList<String> f) {
		this.favorite = f;
		this.read = r;
	}
 	
 	public ArrayList<String> getFavorite() {
		return favorite;
	}
	
	public ArrayList<String> getRead() {
		return read;
	}
}